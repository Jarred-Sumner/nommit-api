class Place < ActiveRecord::Base
  belongs_to :location
  belongs_to :school
  has_many :delivery_places
  has_many :shifts, through: :delivery_places
  has_many :foods, -> { uniq }, through: :delivery_places
  has_many :orders

  scope :active, -> do
    joins(:delivery_places)
    .where(delivery_places: {
      state: [ DeliveryPlace.states[:arrived], DeliveryPlace.states[:ready], DeliveryPlace.states[:pending] ]
    })
  end

  def self.random
    place_number = rand(0..Place.count)
    Place.offset(place_number).first
  end

  def food_count
    delivery_places
      .deliverable
      .joins(:foods)
      .where("foods.state = ? AND ? BETWEEN foods.start_date AND foods.end_date", Food.states[:active], DateTime.now)
      .select("foods.id")
      .uniq
      .count
  end
end
