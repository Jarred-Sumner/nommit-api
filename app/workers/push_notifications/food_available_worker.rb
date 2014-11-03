class PushNotifications::FoodAvailableWorker < PushNotifications::BaseWorker
  attr_reader :food

  def perform(food_id)
    @food = Food.orderable.find_by(id: food_id)

    Device.registered.find_each do |device|
      # next if device.last_notified.present? && device.last_notified < 12.hours.ago
      notification = Grocer::Notification.new(notification_params(device))
      pusher.push(notification)
      device.touch(:last_notified)
    end
  end

  def notification_params(device)
    params = super
    params[:badge] = Food.orderable.count
    params[:expiry] = food.end_date.to_time

    if food.present? && (!device.user.last_ordered || device.user.last_ordered > 3.days.ago)
      params[:alert] = "Hungry? Get #{food.title} delivered to you in under 15 minutes"
    end

    params
  end

end
