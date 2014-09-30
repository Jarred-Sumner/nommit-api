class Delivery < ActiveRecord::Base
  belongs_to :food
  belongs_to :delivery_place
  has_many :orders

  validates :food, presence: true
  validates :delivery_place, presence: true, uniqueness: { scope: :food }
end
