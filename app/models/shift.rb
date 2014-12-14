class Shift < ActiveRecord::Base
  belongs_to :courier
  belongs_to :seller
  has_many :delivery_places, dependent: :destroy
  has_many :places, through: :delivery_places
  has_many :orders, through: :delivery_places
  has_one :user, through: :courier
  has_many :foods, lambda { uniq }, through: :delivery_places

  # Active means ongoing
  # Halted means courier isn't accepting new orders, but in process of delivering old ones
  # Ended means it's over. No more deliveries being made at this time.
  include StateID
  enum state: [:active, :halt, :ended]

  # Couriers leave at DeliveryPlace for time_spent_in_place
  def deliver_to!(places: [])

    stop_delivering_to = delivery_places.where.not(place_id: places)
    if stop_delivering_to.count > 0
      raise ArgumentError, "Cannot stop delivering to #{stop_delivering_to.first.place.name} until your shift ends."
    end

    if halt? && places.count != delivery_places.count
      raise ArgumentError, "Your shift is about to end! Can't deliver to more places until the next shift."
    end

    foods = seller.foods.orderable.pluck(:id)

    transaction do
      places.each do |place_id, index|
        next if delivery_places.where(place_id: place_id).count > 0

        dp = delivery_places.create!(place_id: place_id, arrives_at: nil, state: DeliveryPlace.states[:pending])
        foods.each { |food_id| dp.deliveries.create!(food_id: food_id) }
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
