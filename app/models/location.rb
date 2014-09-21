class Location < ActiveRecord::Base
  validates :address_one, presence: true
  validates :city, presence: true
end
