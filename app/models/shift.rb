class Shift < ActiveRecord::Base
  belongs_to :courier
  belongs_to :seller
  has_many :delivery_places, dependent: :destroy
  has_many :places, through: :delivery_places
  has_many :orders
  has_one :user, through: :courier
  has_many :foods, lambda { uniq }, through: :delivery_places

  # Active means ongoing
  # Halted means courier isn't accepting new orders, but in process of delivering old ones
  # Ended means it's over. No more deliveries being made at this time.
  include StateID
  enum state: [:active, :halt, :ended]

  def payout_calculator
    @payout_calculator ||= PayoutCalculator.new(orders.pluck(:id))
  end

  # Couriers leave at DeliveryPlace for time_spent_in_place
  def deliver!(places: [], foods: nil)

    stop_delivering_to = delivery_places.where.not(place_id: places)
    if stop_delivering_to.count > 0
      raise ArgumentError, "Cannot stop delivering to #{stop_delivering_to.first.place.name} until your shift ends."
    end

    if halt? && places.count != delivery_places.count
      raise ArgumentError, "Your shift is about to end! Can't deliver to more places until the next shift."
    end

    if foods.blank?
      foods = seller.foods.visible.active.pluck(:id)
    end

    sellable_foods = SellableFood.where(id: Food.where(id: foods).pluck(:id) | foods)
    sellable_foods.each do |food|
      i = foods.index(food.id)
      foods[i] = food.versions
        .where("end_date > ?", DateTime.now)
        .where(state: [ Food.states[:active], Food.states[:halted] ])
        .order("end_date ASC")
        .first!
        .id
    end

    foods.sort!

    transaction do
      places.each do |place_id, index|

        dp = delivery_places
          .where("delivery_places.place_id = ?", place_id)
          .first

        # Is it already "in sync"?
        next if dp.present? && dp.foods.pluck("foods.id").sort == foods

        dp ||= DeliveryPlace.new(place_id: place_id, shift_id: id)
        dp.state = DeliveryPlace.states[:pending]
        dp.arrives_at = nil
        dp.save!

        foods.each do |food_id| 
          dp.deliveries.where(food_id: food_id).first_or_create!
        end

      end
    end

  end

  def current_delivery_place
    DeliveryPlace.find_by(shift_id: self.id, state: "arrived")
  end

  # Given [1,2,3,4,5,6]
  # If new_zero_index's value was 3
  # Then, array should return [3,4,5,6,1,2]
  def update_arrival_times!
    active = delivery_places.with_pending_orders

    unless active.collect(&:id).uniq.sort == delivery_places.active.pluck(:id).uniq.sort
      count = active.count
      inactive = delivery_places.pluck(:id).uniq.sort - active.pluck('delivery_places.id').uniq.sort
      transaction do

        state = :pending
        if halt?
          state = :ended
        end

        DeliveryPlace
          .where(id: inactive)
          .update_all(state: DeliveryPlace.states[state], arrives_at: nil, current_index: nil)

        active.each_with_index do |dp, index|
          state = dp.state

          if dp.pending?
            if halt?
              state = "halted"
            else
              state = "ready"
            end
          end

          dp.current_index = index
          dp.generate_eta!
          dp.state = state
          dp.save!

          Notifications::LateWorker.perform_at(dp.arrives_at + 30.seconds, dp.id)
        end

      end
    end

  end

  def ended!
    transaction do
      self.state = :ended
      save!
      delivery_places.update_all(state: DeliveryPlace.states[:ended])
      courier.inactive!
    end
  end

  def halt!
    transaction do
      self.state = :halt
      save!
      delivery_places
        .with_pending_orders
        .update_all(state: DeliveryPlace.states[:halted])
      delivery_places
        .where.not(state: DeliveryPlace.states[:halted])
        .update_all(state: DeliveryPlace.states[:ended])
      update_arrival_times!
    end
  end

  validates :courier, presence: true
  validates :seller, presence: true

  # Only one active Shift at a given time for a Courier
  validates :state, uniqueness: { scope: [:courier], message: "You already have an outstanding shift. Call support for help #{COMPANY_PHONE}." }, if: :active?

  validate :cannot_end_with_pending_orders!, if: :ended?

  def cannot_end_with_pending_orders!
    errors.add(:state, "cannot be ended when there are still orders to deliver") if orders.active.count > 0
  end

  before_validation on: :create do
    self.seller = courier.seller
  end

  after_create do
    courier.active! if active?
  end

end
