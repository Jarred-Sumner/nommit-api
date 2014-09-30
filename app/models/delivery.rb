class Delivery < ActiveRecord::Base
  belongs_to :food
  belongs_to :delivery_place
  has_many :orders

  validates :food, presence: true
  validates :delivery_place, presence: true, uniqueness: { scope: :food }

  validate :food_is_owned_by_seller!

  private

    def food_is_owned_by_seller!
      errors.add(:food, "can only be delivered by the seller") unless self.food.seller_id == self.delivery_place.seller.id
    end
end
