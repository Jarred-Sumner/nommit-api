class Sms::Notifications::DeliveryWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    message = "#{order.user.first_name}, we really hope you liked your food. If there's any food you wish we had on Nommit, text us at #{COMPANY_PHONE} -- we <3 recommendations!"
    Texter.run(message, order.user.phone)
  end
end
