class Delivery < ActiveRecord::Base
  belongs_to :food
  belongs_to :delivery_place
  has_many :orders

  validates :food, presence: true
  validates :delivery_place, presence: true, uniqueness: { scope: :food }

  validate :food_is_owned_by_seller!

  def self.for(place_id: nil, food_id: nil)
    deliverable = [ DeliveryPlace.states[:ready], DeliveryPlace.states[:arrived], DeliveryPlace.states[:pending] ]
    Delivery.joins(:delivery_place).where(delivery_places: { place_id: place_id, state: deliverable }, food_id: food_id)
  end

  def active?
    delivery_place.ready? || delivery_place.arrived? || delivery_place.pending?
  end

  private

    def food_is_owned_by_seller!
      errors.add(:food, "can only be delivered by the seller") unless self.food.seller_id == self.delivery_place.seller.id
    end

end
