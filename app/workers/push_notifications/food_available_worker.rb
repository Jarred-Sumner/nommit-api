class PushNotifications::FoodAvailableWorker < PushNotifications::BaseWorker
  attr_reader :food

  def perform(food_id)
    @food = Food.find_by(id: food_id)

    Device.registered.find_each do |device|
      notification = Grocer::Notification.new(notification_params(device))
      pusher.push(notification)
      device.touch(:last_notified)
    end
  end

  def notification_params(device)
    params = super
    params[:badge] = Food.orderable.count

    if food.orderable?
      params[:expiry] = food.end_date.to_time
      params[:alert] = "Hungry? #{food.seller.name} is delivering food right now!"
    end

    params
  end

end
