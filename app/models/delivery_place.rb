class DeliveryPlace < ActiveRecord::Base
  belongs_to :shift
  belongs_to :place
  belongs_to :seller
  has_many :deliveries, dependent: :destroy
  has_many :foods, through: :deliveries
  has_many :orders, through: :deliveries
  has_one :courier, through: :shift

  include StateID
  enum state: [:ready, :arrived, :halted, :ended, :pending]
  scope :deliverable, -> do
    states = [ DeliveryPlace.states[:ready], DeliveryPlace.states[:arrived], DeliveryPlace.states[:pending] ]
    where(state: states)
  end

  scope :active, -> do
    states = [ DeliveryPlace.states[:ready], DeliveryPlace.states[:arrived] ]
    where(state: states).order("current_index ASC")
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

end
