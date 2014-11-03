class PushNotifications::FoodAvailableWorker
  include Sidekiq::Worker
  CERTIFICATE_PATH = ENV["APN_CERTIFICATE_PATH"] unless defined?(CERTIFICATE_PATH)
  attr_reader :food

  def perform(food_id)
    @food = Food.find(food_id)

    Device.registered.find_each do |device|
      next if device.last_notified.present? && device.last_notified < 12.hours.ago

      notification_params = {
        device_token: device.token,
        badge: Food.orderable.count,
        expiry: food.end_date.to_time
      }

      if !device.user.last_ordered || device.user.last_ordered < 3.days.ago
        notification_params[:alert] = "Get #{food.title} delivered to you in under 15 minutes right now"
      end

      pusher.push(notification_params)
      device.touch(:last_notified)
    end
  end

  def pusher
    @pusher ||= Grocer.pusher(certificate: CERTIFICATE_PATH)
  end

end
