class ChargeWorker
  attr_reader :order, :charge
  include Sidekiq::Worker

  def perform(order_id)
    @order = Order.find(order_id)
    @charge = order.charge

    ActiveRecord::Base.transaction do
      return false if charge.state.to_sym != :not_charged && charge.state.to_sym != :failed
      charge.amount_charged_in_cents = order.price_in_cents + order.tip_in_cents - order.discount_in_cents
      if charge.amount_charged_in_cents > 0
        charge_card!
      else
        charge.state = :paid
        charge.save!
      end
    end

  end

  def charge_card!
    description = "#{order.quantity}x - #{order.food.title} from #{order.seller.name} "
    description << "plus $#{Float(order.tip_in_cents) / 100.0} tip " if order.tip_in_cents > 0
    description << "using #{Float(order.discount_in_cents) / 100.0} in Nommit credit " if order.discount_in_cents > 0

    stripe_charge = Stripe::Charge.create(
      amount: charge.amount_charged_in_cents,
      currency: "usd",
      customer: charge.payment_method.customer,
      receipt_email: order.user.email,
      description: description,
      statement_description: "Food on Nommit",
      metadata: {
        email: order.user.email,
        order_id: order.id,
        food_id: order.food_id
      }
    )

    if stripe_charge.paid
      charge.charge = stripe_charge.id
      charge.state = :paid
    else
      charge.state = :failed
      charge.payment_method.failed!
    end

  rescue Stripe::CardError
    charge.state = :failed
    charge.payment_method.failed!
  ensure
    charge.save!
  end

end
