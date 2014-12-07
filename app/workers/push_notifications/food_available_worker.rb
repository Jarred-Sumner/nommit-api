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
    params[:badge] = 1

    if food.orderable?
      params[:expiry] = food.end_date.to_time
      price = number_to_currency(food.prices.first.price_in_cents / 100)

      if food.seller.name.include?("Nommit")
        params[:alert] = "Hungry? Get #{food.title} from #{food.restaurant.name} delivered for #{price} in under 15 minutes!"
      else
        params[:alert] = "Hungry? #{food.seller.name} is delivering #{food.title} for #{price} right now"
      end

      if user.present? && user.credit > 0
        credit = number_to_currency(user.credit / 100.0)
        params[:alert] << ", and you have #{credit} in free credit left."
      end

    end

    params
  end

end
