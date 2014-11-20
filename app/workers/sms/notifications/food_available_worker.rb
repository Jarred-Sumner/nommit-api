class SMS::Notifications::FoodAvailableWorker
  include Sidekiq::Worker
  include ActionView::Helpers::NumberHelper
  attr_accessor :user, :food
  attr_reader :message

  def perform(user_id, food_id)
    self.user = User.find(user_id)
    self.food = Food.find(food_id)

    if food.orderable? && user.phone.present?
      price = number_to_currency(food.prices.first.price_in_cents / 100)
      if food.seller.name.include?("Nommit")
        @message = "Yo #{user.first_name}! Hungry? Get #{food.title} for #{price} delivered on Nommit right now - http://getnommit.com"
      else
        @message = "Yo #{user.first_name}! #{food.seller.name} is delivering #{food.title} on Nommit right now - http://getnommit.com"
      end

      if user.credit > 0

        credit_left = number_to_currency(user.credit / 100.0)
        @message << ", and you have #{credit_left} in credit left."

      end

      # We use the invite phone here because this is the one where it's safe to overload it with text messages
      Texter.run(@message, user.phone, InviteWorker::INVITE_PHONE)
    end

  end

end
