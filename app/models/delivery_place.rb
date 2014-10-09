class DeliveryPlace < ActiveRecord::Base
  belongs_to :shift
  belongs_to :place
  belongs_to :seller
  has_many :deliveries, dependent: :destroy
  has_many :foods, through: :deliveries
  has_many :orders, through: :deliveries
  has_one :courier, through: :shift

  include StateID
  enum state: [:ready, :arrived, :halted, :ended]
  scope :active, lambda { where("state = ? OR state = ?", DeliveryPlace.states[:ready], DeliveryPlace.states[:arrived]) }

  validates :shift, presence: true
  validates :place, presence: true, uniqueness: { scope: :shift_id }
  validates :state, uniqueness: { scope: :shift_id }, if: :arrived?

  validates :current_index, presence: true, uniqueness: { :scope => [:shift_id, :place_id] }
  validates :start_index, presence: true, uniqueness: { :scope => [:shift_id, :place_id] }

  before_validation on: :create do
    self.seller_id = courier.seller_id
    self.start_index = current_index
  end

  validate :no_orders_remaining, if: :ended?
  def no_orders_remaining
    errors.add(:base, "Can't stop delivering until remaining orders are delivered") if self.orders.pending.count > 0
  end

  def arrive!
    transaction do
      orders.arrived.update_all(state: Order.states[:active])
      shift
        .delivery_places
        .update_all(state: DeliveryPlace.states[:ready])

      arrived!
      orders.pending.update_all(state: Order.states[:arrived])

      shift.update_delivery_times!(current_index)
    end
  end

  validate :isnt_handled_by_another_courier!, on: :create
  def isnt_handled_by_another_courier!
    if self.seller.delivery_places.active.where(place_id: place_id).count > 0
      errors.add(:base, "#{place.name} is already being handled by another courier")
    end
  end

end
