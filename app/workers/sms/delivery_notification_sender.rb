class Sms::DeliveryNotificationSender
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    message = "#{order.user.first_name}, thanks for ordering with Nommit. If you have any questions, don't hesitate to text us at #{COMPANY_PHONE}"
    Texter.new(message, order.user.phone).perform
  end
end
