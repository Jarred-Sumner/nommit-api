class ChargeWorker
  include Sidekiq::Worker
  sidekiq_options queue: :charges

  def perform(order_id)
    order = Order.find(order_id)
    charge = order.charge

    ActiveRecord::Base.transaction do
      return false if charge.state != Charge.states[:not_charged] && charge.state != Charge.states[:failed]

      charge.amount_charged_in_cents = order.price_in_cents + order.tip_in_cents - order.discount_in_cents

      description = "#{order.quantity}x - #{order.food.title} from #{order.seller.name}"
      description << "plus $#{Float(order.tip_in_cents) / 100.0} tip" if order.tip_in_cents > 0
      description << "using #{order.discount_in_cents} in Nommit credit" if order.discount_in_cents > 0
      begin
        stripe_charge = Stripe::Charge.create(
          amount: amount_charged_in_cents,
          currency: "usd",
          customer: payment_method.customer,
          receipt_email: order.user.email,
          description: description,
          statement_description: "#{order.quantity}x - #{order.food.title}".truncate(15),
          metadata: {
            email: order.user.email,
            order_id: order.id,
            food_id: order.food_id
          }
        )

        if stripe_charge.paid?
          charge.state = :paid
        else
          charge.state = :failed
          payment_method.failed!
        end

      rescue Stripe::CardError
        charge.state = :failed
        payment_method.failed!
      ensure
        charge.save!
      end

    end

  end

end
