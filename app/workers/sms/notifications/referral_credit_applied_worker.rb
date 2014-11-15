class SMS::Notifications::ReferralCreditAppliedWorker
  include Sidekiq::Worker
  attr_accessor :applied_promo, :referred, :referrer

  def perform(referral_promo_id)
    self.applied_promo = AppliedPromo.find(referral_promo_id)
    self.referred = applied_promo.user
    self.referrer = applied_promo.referrer

    Texter.run(message, referrer.user.phone)
  end

  def message
    "You've just earned $5 more in credit on Nommit! Thanks for referring #{referred.first_name}"
  end

end
