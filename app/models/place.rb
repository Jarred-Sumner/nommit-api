class Place < ActiveRecord::Base
  belongs_to :location
  has_and_belongs_to_many :foods
  scope :active, -> { joins(:foods).where(foods: { state: Food::STATES[:active] } ) }
end
