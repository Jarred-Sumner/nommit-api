class PaymentMethod < ActiveRecord::Base
  belongs_to :user
  has_many :charges
  has_many :orders, through: :charges
  include StateID
  enum state: [:active, :failed]

  def create_for(token: nil, user: nil)
    customer = Stripe::Customer.create(description: "Customer for #{user.email}", card: token)
  rescue Stripe::CardError => e
  rescue Stripe::InvalidRequestError => e
  end

end
