class SMS::Notifications::FoodAvailableWorker
  include Sidekiq::Worker
  include ActionView::Helpers::NumberHelper
  attr_accessor :user, :food
  attr_reader :message

  def perform(user_id, food_id)
    self.user = User.find(user_id)
    self.food = Food.find(food_id)

    if food.orderable? && user.phone.present?

      if food.seller.name.include?("Nommit")
        @message = "Yo #{user.first_name}! Hungry? #{food.title} is being delivered on Nommit right now"
      else
        @message = "Yo #{user.first_name}! #{food.seller.name} is delivering #{food.title} on Nommit right now"
      end

      if user.credit > 0

        credit_left = number_to_currency(user.credit / 100.0)
        @message << ", and you have #{credit_left} in credit left."

      end

      Texter.run(@message, user.phone)
    end

  end

end
