class FoodsMailer < ApplicationMailer

  def new(food_id, user_id)
    @user = User.emailable.find(user_id)
    @food = Food.orderable.find(food_id)

    if @food.seller.name.include?("Nommit")
      price = number_to_currency(@food.prices.first.price_in_cents / 100)
      @subject = "Get #{@food.title} from #{@food.restaurant.name} delivered for #{price} to CMU"
    else
      @subject = "#{@food.seller.name} is delivering #{@food.title} right now!"
    end

    mail to: @user.email, subject: @subject
  end
end
