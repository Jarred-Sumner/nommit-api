class PushNotifications::Courier::HurryUpWorker < PushNotifications::BaseWorker
  include ActionView::Helpers::DateHelper

  def perform(order_id)
    order = Order.find(order_id)
    return false if order.completed? || order.delivered_at > 3.minutes.from_now

    courier = order.courier
    courier.user.devices.each do |device|
      params = notification_params(device)
      time = distance_of_time_in_words(order.delivered_at, Time.now)

      params[:alert] = "You're almost late! You have #{time} to get to #{order.place.name} and deliver #{order.delivery_place.orders.pending.count} orders."
      params[:badge] = order.shift.orders.pending.count

      pusher.push(Grocer::Notification.new(params))
    end

  end

end
