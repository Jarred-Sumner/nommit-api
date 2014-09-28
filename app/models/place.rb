class Place < ActiveRecord::Base
  belongs_to :location
  has_many :food_delivery_places
  has_many :foods, through: :food_delivery_places
  scope :active, -> { joins(:food_delivery_places).where(food_delivery_places: { state: "active" }) }

  def self.random
    place_number = rand(0..Place.count)
    Place.offset(place_number).first
  end
end
