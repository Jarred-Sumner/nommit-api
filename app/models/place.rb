class Place < ActiveRecord::Base
  belongs_to :location
  has_and_belongs_to_many :foods
  scope :active, -> { joins(:foods).where(foods: { state: Food::STATES[:active] } ) }

  def self.random
    place_number = rand(0..Place.count)
    Place.offset(place_number).first
  end
end
