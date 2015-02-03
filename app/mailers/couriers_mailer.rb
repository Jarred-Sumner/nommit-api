class CouriersMailer < ApplicationMailer

  def create(courier_id)
    @courier = Courier.find(courier_id)
    @user = @courier.user

    mail to: @user.email, subject: "You can now deliver for #{@courier.seller.name}"
  end

end