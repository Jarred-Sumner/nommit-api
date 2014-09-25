class Courier < ActiveRecord::Base
  belongs_to :user
  belongs_to :seller
  has_many :delivery_locations
  has_many :places, through: :delivery_locations
  has_many :deliveries
  
  enum state: { inactive: 0, active: 1 }
  include StateID
end
