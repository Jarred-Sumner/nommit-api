class AppliedPromosMailer < ApplicationMailer

  def new(applied_promo_id)
    @applied_promo = AppliedPromo.find(applied_promo_id)
    @user = @applied_promo.user

    @credit = number_to_currency(@applied_promo.amount_remaining_in_cents / 100)
    mail to: @user.email, subject: "#{@credit} credit has been applied to your account"
  end
end
