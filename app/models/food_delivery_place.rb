class FoodDeliveryPlace < ActiveRecord::Base
  include ActiveModel::Dirty
  include StateID
  MAX_WAIT_TIME = 15 unless defined?(MAX_WAIT_TIME)
  TRAVEL_INTERVAL_SECONDS = 300 unless defined?(TRAVEL_INTERVAL_SECONDS)

  belongs_to :food
  belongs_to :place
  belongs_to :courier
  belongs_to :seller

  enum state: [:ready, :active, :ended]
  scope :deliverable, -> { joins(:food).where("foods.end_date > ? AND (foods.state = ? OR foods.state = ?)", DateTime.now, Food.states[:ready], Food.states[:active]) }

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
      eta = eta_for(index: index, wait_interval: wait_interval)
      delivery_places.update_all(courier_id: courier.id, state: FoodDeliveryPlaces.states[:active], wait_interval: wait_interval, index: index, eta: eta)
    end
  end

  private

    def self.eta_for(index: 0, wait_interval: 300)
      seconds = (index + 1) * wait_interval + TRAVEL_INTERVAL_SECONDS
      seconds.seconds.from_now
    end


  validates :food, presence: true, uniqueness: { scope: :place }, if: -> { ready? || active? }
  validates :place, presence: true
  validates :seller, presence: true

  with_options if: lambda { |fdp| fdp.active? } do |fdp|
    validates :courier, presence: true
    validates :eta, presence: true
  end

  after_commit if: -> { ended? && !food.ended? } do
    food.ended! if food.food_delivery_places.active.empty?
  end

  before_validation on: :create do
    self.seller = food.seller
  end
end
