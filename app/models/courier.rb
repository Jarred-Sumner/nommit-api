class Courier < ActiveRecord::Base
  belongs_to :user
  belongs_to :seller
  has_many :food_delivery_places
  has_many :places, -> { uniq },  through: :food_delivery_places
  has_many :deliveries

  enum state: { inactive: 0, active: 1 }
  include StateID
end
