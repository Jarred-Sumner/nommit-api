class PushNotifications::DeliveryWorker < PushNotifications::BaseWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    deliverer = Courier.find(order.courier).user

    deliverer.devices.each do |device|
      params = notification_params(device)
      params[:alert] = "New Delivery! #{order.place.name}: #{order.quantity} of #{order.food.title} for #{order.user.first_name}"
      params[:badge] = order.shift.orders.pending.count

      pusher.push(Grocer::Notification.new(params))
    end
  end

end
