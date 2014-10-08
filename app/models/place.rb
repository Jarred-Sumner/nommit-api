class Place < ActiveRecord::Base
  belongs_to :location
  has_many :delivery_places
  has_many :shifts, through: :delivery_places
  has_many :foods, lambda { uniq }, through: :delivery_places
  has_many :orders

  scope :active, -> do
    joins(:delivery_places)
    .where(delivery_places: {
      state: [ DeliveryPlace.states[:arrived], DeliveryPlace.states[:ready] ]
    })
  end
  
  def self.random
    place_number = rand(0..Place.count)
    Place.offset(place_number).first
  end

  def food_count
    active = [DeliveryPlace.states[:arrived], DeliveryPlace.states[:ready]]
    self.foods.orderable.where(delivery_places: { state: active } ).count
  end
end
