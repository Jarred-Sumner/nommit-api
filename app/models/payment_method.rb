class PaymentMethod < ActiveRecord::Base
  belongs_to :user
  has_many :charges
  has_many :orders, through: :charges
  include StateID
  enum state: [:active, :failed, :deactivated]

  def self.create_for(token: nil, user: nil)
    customer = Stripe::Customer.create(description: "Customer for #{user.email}", card: token)

    transaction do
      PaymentMethod.where(user_id: user.id).active.update_all(state: PaymentMethod.states[:deactivated])

      PaymentMethod.create! do |payment_method|
        payment_method.customer = customer.id
        payment_method.last_four = Integer(customer.cards.first.try(:last4))
        payment_method.card_type = customer.cards.first.try(:brand).try(:downcase)
        payment_method.user_id = user.id
        payment_method.state = PaymentMethod.states[:active]
      end

    end
  end

  validates :state, presence: true
end
