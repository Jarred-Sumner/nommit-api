class PaymentMethod < ActiveRecord::Base
  belongs_to :user
  has_many :charges
  has_many :orders, through: :charges
  include StateID
  enum state: [:active, :failed, :deactivated]

  def self.create_for(token: nil, user: nil)
    customer = Stripe::Customer.create(
      email: user.email,
      card: token,
      metadata: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone
      }
    )

    transaction do
      PaymentMethod.where(user_id: user.id).active.update_all(state: PaymentMethod.states[:deactivated])

      payment = PaymentMethod.create! do |payment_method|
        payment_method.customer = customer.id
        payment_method.last_four = Integer(customer.cards.first.try(:last4))
        payment_method.card_type = customer.cards.first.try(:brand).try(:downcase)
        payment_method.user_id = user.id
        payment_method.state = PaymentMethod.states[:active]
      end

      # Charge previously failed charges with new payment method
      # If it fails again, it will have them re-enter their payment method again.
      # TODO: flag frequently failed users with payment methods if this becomes a problem
      failed_charges = Charge
        .joins(:payment_method)
        .where(payment_method: { id: user.payment_methods.failed.pluck(:id) })
      failed_charges.update_all(payment_method_id: payment.id)
      failed_charges.pluck(:id).each { |charge| ChargeWorker.perform_async(charge.order_id) }

    end

    # Bust user cache
    user.touch
  end

  validates :state, presence: true
end
