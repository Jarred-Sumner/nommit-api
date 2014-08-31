class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user

  has_one :address, as: :addressable
end
