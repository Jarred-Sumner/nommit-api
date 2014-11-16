class PushNotifications::FoodUnavailableWorker < PushNotifications::BaseWorker
  attr_accessor :food

  def perform(food_id)
    self.food = Food.find(food_id)

    unless self.food.ended?

      if food.end_date.past?
        food.update_attributes(state: Food.states[:ended])
      else
        PushNotifications::FoodUnavailableWorker.perform_at(food.end_date, food.id)
        return
      end

    end

    orderable = Food.orderable.count
    User.activated.select(:id).find_each do |user|

      user.devices.registered.each do |device|
        params = notification_params(device)
        params[:badge] = orderable
        params.delete(:alert) if params.has_key?(:alert)

        pusher.push(Grocer::Notification.new(params))

        device.touch(:last_notified)
      end

    end

  end

end
