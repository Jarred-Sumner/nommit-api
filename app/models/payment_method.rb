class PaymentMethod < ActiveRecord::Base
  belongs_to :user
  has_many :charges
  has_many :orders, through: :charges
  include StateID
  enum state: [:active, :failed, :deactivated]

  def self.create_for(token: nil, user: nil)
    customer = Stripe::Customer.create(description: "Customer for #{user.email}", card: token)

    transaction do
      user.payment_method.try(:deactivated!)

      PaymentMethod.create! do |payment_method|
        payment_method.customer = customer.id
        payment_method.user = user
        payment_method.state = PaymentMethod.states[:active]
      end
    end
  end

  validates :state, presence: true
end
