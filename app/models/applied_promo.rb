class AppliedPromo < ActiveRecord::Base
  belongs_to :referrer, class_name: AppliedPromo
  has_many :referrals, class_name: AppliedPromo, foreign_key: "referrer_id"
  belongs_to :user
  belongs_to :promo
  has_and_belongs_to_many :orders

  enum state: [:active, :used_up, :inactive]

  validates :user_id, uniqueness: { scope: [:promo_id], message: "has already applied this promo" }
  validates :amount_remaining_in_cents, presence: true
  validate :user_didnt_create_promo!, if: :active?

  before_validation on: :create do
    if self.promo.class == ReferralPromo

      if self.promo.user_id.present? && self.promo.user_id != user_id
        self.referrer = AppliedPromo.create!(state: :inactive, user_id: self.promo.user_id, promo_id: self.promo_id)
      end

    end
    self.amount_remaining_in_cents = promo.discount_in_cents
  end

  def usable?
    promo.active? && active?
  end

  private

    def user_didnt_create_promo!
      return if self.referrals.count > 0
      if self.promo.user_id == self.user_id
        self.errors.add(:base, "Can't use your own referral code")
      end
    end

end
