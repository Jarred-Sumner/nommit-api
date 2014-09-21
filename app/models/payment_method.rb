class PaymentMethod < ActiveRecord::Base
  belongs_to :user
  has_many :charges
  has_many :orders, through: :transactions
end
