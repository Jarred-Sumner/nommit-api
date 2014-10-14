class Price < ActiveRecord::Base
  belongs_to :food
  has_many :orders

  validates :quantity, presence: true, uniqueness: { scope: :food_id }
  validates :price_in_cents, presence: true, numericality: { only_integer: true, greater_than: 299 }
end
