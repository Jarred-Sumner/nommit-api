class PushNotifications::FoodAvailableWorker < PushNotifications::BaseWorker
  attr_accessor :food
  include ActionView::Helpers::NumberHelper

  def perform(food_id, user_id)
    self.food = Food.find_by(id: food_id)
    self.user = User.find(user_id)

    user.devices.registered.each do |device|
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

      if food.seller.name.include?("Nommit")
        params[:alert] = "Hungry? Get #{food.title} delivered in under 15 minutes"
      else
        params[:alert] = "Hungry? #{food.seller.name} is delivering #{food.title} right now"
      end

      if user.present? && user.credit > 0
        credit = number_to_currency(user.credit / 100.0)
        params[:alert] << ", and you have #{credit} in free credit left."
      end

    end

    params
  end

end
