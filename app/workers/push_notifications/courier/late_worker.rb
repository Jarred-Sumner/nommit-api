class PushNotifications::Courier::LateWorker < PushNotifications::BaseWorker
  attr_accessor :delivery_place
  sidekiq_options queue: :late

  def perform(delivery_place_id)
    self.delivery_place ||= DeliveryPlace.find(delivery_place)
    return false unless delivery_place.late?

    delivery_place.courier.user.devices.each do |device|
      notification = Grocer::Notification.new(notification_params(device))
      pusher.push(notification)
    end

  end

  def notification_params(device)
    params = super

    params[:alert] = "Hurry! You're late to deliver #{delivery_place.orders.pending.count} orders to #{delivery_place.place.name} - that's #{ number_to_currency PayoutCalculator::LATE_FEE } lost per minute of being late."

    params
  end

end