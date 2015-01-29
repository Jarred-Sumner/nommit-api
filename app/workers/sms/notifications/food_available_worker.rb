class SMS::Notifications::FoodAvailableWorker
  include Sidekiq::Worker
  include ActionView::Helpers::NumberHelper
  attr_accessor :user, :food
  attr_reader :message

  def perform(user_id, food_id)
    self.user = User.find(user_id)
    self.food = Food.notifiable.find(food_id)

    if food.orderable? && user.phone.present?
      return false unless user.subscription.try(:sms?)
      price = number_to_currency(food.price.price_in_cents / 100)
      @message = "Hungry? Get #{food.title} from #{food.restaurant.name} for #{price} delivered to you on Nommit in < 15 min - http://getnommit.com?sms=true"

      if user.credit > 0

        credit_left = number_to_currency(user.credit / 100.0)
        @message << ", and you have #{credit_left} in credit left."

      end

      # We use the invite phone here because this is the one where it's safe to overload it with text messages
      Texter.run(@message, user.phone, InviteWorker::INVITE_PHONE)
    end

  end

end
