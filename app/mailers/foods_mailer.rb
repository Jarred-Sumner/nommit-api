class FoodsMailer < ApplicationMailer

  def new(food_id, user_id)
    @user = User.emailable.find(user_id)
    @food = Food.orderable.find(food_id)
    mail to: @user.email, subject: "#{@food.seller.name} is delivering #{@food.title} right now!"
  end
end
