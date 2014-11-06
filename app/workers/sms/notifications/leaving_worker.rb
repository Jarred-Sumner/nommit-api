require 'action_view'

class Sms::Notifications::LeavingWorker
  include Sidekiq::Worker
  include ActionView::Helpers::DateHelper
  sidekiq_options retry: false

  def perform(id)
    delivery_place = DeliveryPlace.find(id)
    delivery_place.orders.pending.find_each do |order|
      deliver_message!(order)
    end
  end

  def deliver_message!(order)
    user = order.user
    courier_user = order.courier.user
    message = "#{courier_user.first_name} had to make more deliveries, but should be back by #{distance_of_time_in_words(order.delivered_at)}"
    Texter.run(message, order.user.phone)
  end

end
