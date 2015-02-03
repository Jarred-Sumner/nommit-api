class SellersMailer < ApplicationMailer

  def apply_reminder(user_id)
    @user = User.find(user_id)
    mail to: "support@getnommit.com", subject: "New Seller Application"
  end

  def apply(user_id)
    @header_hidden = true

    @user = User.find(user_id)
    mail to: @user.email, subject: "Selling Food on Nommit", from: "Jarred Sumner <jarred@getnommit.com>"
  end

end
