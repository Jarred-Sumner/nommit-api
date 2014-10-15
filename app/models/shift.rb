class Shift < ActiveRecord::Base
  belongs_to :courier
  belongs_to :seller
  has_many :delivery_places, dependent: :destroy
  has_many :places, through: :delivery_places
  has_many :orders, through: :delivery_places
  has_many :foods, lambda { uniq }, through: :delivery_places
  LONGEST_DELIVER_TIME = 15.0 unless defined?(LONGEST_DELIVER_TIME)
  DELIVERY_PADDING = 2 unless defined?(DELIVERY_PADDING)

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
      raise ArgumentError, "Your shift is about to end! I can't let you start delivering to more places until the next shift."
    end

    foods = seller.foods.active.pluck(:id)

    transaction do
      places.each_with_index do |place_id, index|
        next if delivery_places.where(place_id: place_id).count > 0

        dp = delivery_places.create!(place_id: place_id, arrives_at: eta_for(index, places.count), current_index: index)
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
  def update_delivery_times!(zero = current_delivery_place.current_index)
    places = delivery_places.order("current_index ASC").to_a
    count = places.count

    places = places[zero..count - 1] | places

    transaction do
      places.each_with_index do |place, index|
        place.update_attributes!(current_index: index, arrives_at: eta_for(index, count))
        place.orders.update_all(delivered_at: eta_for(index, count) + DELIVERY_PADDING.minutes)
      end
    end

  end

  def eta_for(index, place_count)
    time_spent_in_place = LONGEST_DELIVER_TIME / place_count.to_f
    (time_spent_in_place * (index + 1)).minutes.from_now
  end

  def ended!
    transaction do
      self.state = :ended
      save!
      delivery_places.update_all(state: DeliveryPlace.states[:ended])
      courier.inactive!
      Sms::Notifications::ShiftEndingWorker.perform_async(id)
    end
  end

  def halt!
    transaction do
      self.state = :halt
      save!
      delivery_places.update_all(state: DeliveryPlace.states[:halted])
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
