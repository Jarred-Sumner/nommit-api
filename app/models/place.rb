class Place < ActiveRecord::Base
  belongs_to :location
  has_many :delivery_places
  has_many :shifts, through: :delivery_places
  has_many :foods, lambda { uniq }, through: :delivery_places
  has_many :orders
  scope :active, -> { joins(:delivery_places).where(delivery_places: { state: "arrived" }) }

  def self.random
    place_number = rand(0..Place.count)
    Place.offset(place_number).first
  end

  def food_count
    delivery_places
      .active
      .joins(:deliveries)
      .select("deliveries.food_id")
      .uniq("deliveries.food_id")
      .count
  end
end
