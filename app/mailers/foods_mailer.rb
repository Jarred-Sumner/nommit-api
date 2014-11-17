class FoodsMailer < ActionMailer::Base
  default from: "support@getnommit.com"

  def new(food_id, user_id)
    @user = User.emailable.find(user_id)
    @food = Food.orderable.find(food_id)

    if @food.seller.name.include?("Nommit")
      @subject = "Get #{@food.title} delivered to CMU right now!"
    else
      @subject = "#{@food.seller.name} is delivering #{@food.title} right now!"
    end

    mail to: @user.email, subject: @subject
  end
end
