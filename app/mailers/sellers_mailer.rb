class SellersMailer < ApplicationMailer

  def apply_reminder(user_id)
    @user = User.find(user_id)
    mail to: "support@getnommit.com", subject: "New Seller Application"
  end

  def apply(user_id)
    @user = User.find(user_id)
    mail to: "support@getnommit.com", subject: "Your Application has been submitted"
  end

end
