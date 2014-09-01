class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: ture

  validates :addressable, presence: true, uniqueness: true
  validates :address_one, presence: true
  validates :city, presence: true
end
