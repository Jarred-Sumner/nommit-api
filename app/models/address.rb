class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  validates :addressable, presence: true, uniqueness: true
  validates :address_one, presence: true
  validates :city, presence: true
end
