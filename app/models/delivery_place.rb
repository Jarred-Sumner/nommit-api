class DeliveryPlace < ActiveRecord::Base
  belongs_to :shift
  belongs_to :place
  belongs_to :seller
  has_many :deliveries, dependent: :destroy
  has_many :foods, through: :deliveries
  has_many :orders, through: :deliveries
  has_one :courier, through: :shift
  LONGEST_DELIVER_TIME = 15.0 unless defined?(LONGEST_DELIVER_TIME)

  include StateID
  enum state: [:ready, :arrived, :halted, :ended, :pending]
  scope :deliverable, -> do
    states = [ DeliveryPlace.states[:ready], DeliveryPlace.states[:arrived], DeliveryPlace.states[:pending] ]
    where(state: states)
  end

  scope :active, -> do
    states = [ DeliveryPlace.states[:ready], DeliveryPlace.states[:arrived], DeliveryPlace.states[:halted] ]
    where(state: states).order("current_index ASC")
  end

  scope :with_pending_orders, -> do
    joins(:orders)
      .where(orders: { state: [ Order.states[:active], Order.states[:arrived] ] })
      .order("orders.delivered_at ASC")
  end

  validates :shift, presence: true
  validates :place, presence: true, uniqueness: { scope: :shift_id }
  validates :state, uniqueness: { scope: :shift_id }, if: :arrived?

  validates :current_index, uniqueness: { :scope => [:shift_id, :place_id], allow_nil: true }

  before_validation on: :create do
    self.seller_id = courier.seller_id
  end

  validate :no_orders_remaining, if: :ended?
  def no_orders_remaining
    errors.add(:base, "Can't stop delivering until remaining orders are delivered") if self.orders.pending.count > 0
  end

  def arrive!
    transaction do
      shift
        .orders
        .arrived
        .update_all(state: Order.states[:active])

      shift
        .delivery_places
        .active
        .update_all(state: DeliveryPlace.states[:ready])

      arrived!
      shift.update_arrival_times!
      notify_pending_orders!
    end
  end

  def notify_pending_orders!
    orders.pending.update_all(state: Order.states[:arrived])
    Sms::Notifications::ArrivalWorker.perform_async(shift_id)
  end

  def left!
    transaction do
      orders.pending.update_all(state: Order.states[:active])
      ready!

      shift.update_arrival_times!
      Sms::Notifications::LeavingWorker.perform_async(id)
    end
  end

  def active?
    ready? || arrived?
  end

  def late?
    active? && arrives_at < 0.seconds.ago
  end

  def accepting_new_deliveries?
    active? || pending?
  end

  validate :isnt_handled_by_another_courier!, on: :create
  def isnt_handled_by_another_courier!
    if seller.delivery_places.active.where(place_id: place_id).count > 0
      errors.add(:base, "#{place.name} is already being handled by another courier")
    end
  end

  def buyer_state_id
    if state_id == DeliveryPlace.states[:pending]
      DeliveryPlace.states[:ready]
    else
      state_id
    end
  end

  def generate_eta!
    eta = nil

    # Courier *needs* to arrive by this point for them to be on time
    ceiling = orders
      .pending
      .order("delivered_at ASC")
      .first
      .try(:delivered_at)

    if recommended_eta.present? && ceiling.present?

      # If they're running slow, and the recommended ETA is past the time they *need* to be there by
      # We defer to the time they *need* to be there by
      if recommended_eta > ceiling
        eta = ceiling
      else
        eta = recommended_eta
      end

    else
      eta = recommended_eta || ceiling
    end

    self.arrives_at = eta
  end

  private

  def recommended_eta
    place_count = shift.delivery_places.with_pending_orders.count

    time_spent_in_place = LONGEST_DELIVER_TIME / place_count.to_f
    @eta = (time_spent_in_place * (current_index + 1) ).minutes.from_now

    if @eta > 15.minutes.from_now
      @eta = 15.minutes.from_now
    else
      @eta
    end
  end

end
