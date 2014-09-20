class PaymentMethod < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
  has_many :orders, through: :transactions
end
