class FoodDeliveryPlace < ActiveRecord::Base
  belongs_to :food
  belongs_to :place
  belongs_to :courier
  belongs_to :seller
  include StateID
  enum state: [:ready, :active, :ended]
  scope :deliverable, -> { joins(:food).where("foods.end_date > ? AND (foods.state = ? OR foods.state = ?)", DateTime.now, Food.states[:ready], Food.states[:active]) }
  MAX_WAIT_TIME = 15 unless defined?(MAX_WAIT_TIME)

  def orders
    @orders ||= Order.where(food: self.food, place: self.place)
  end

  # Courier delivers Food to Place on behalf of a Seller
  # We assign a courier to deliver foods to given places
  # There's a time they're expected to wait at each place, before moving onto the next one.
  def self.assign_courier(seller: nil, places: [], courier: nil)
    wait_interval = places.count / MAX_WAIT_TIME
    places.each_with_index do |place_id, index|
      delivery_places = where(seller_id: seller.id, place_id: place_id)
      delivery_places.update_all(courier_id: courier.id, state: FoodDeliveryPlaces.states[:active], wait_interval: wait_interval, index: index)
    end
  end

  validates :food, presence: true, uniqueness: { scope: :place }, if: -> { ready? || active? }
  validates :place, presence: true
  validates :seller, presence: true
  validates :courier, presence: true, if: -> { active? }

  after_commit if: -> { ended? && !food.ended? } do
    if food.food_delivery_places.active.empty?
      food.ready!
    end
  end

  after_commit if: -> { active? } do
    food.active! if food.ready?trye
  end

  before_validation on: :create do
    self.seller = food.seller
  end
end
