class AppliedPromo < ActiveRecord::Base
  belongs_to :referrer, class_name: AppliedPromo
  has_many :referrals, class_name: AppliedPromo, foreign_key: "referrer_id"
  belongs_to :user
  belongs_to :promo
  has_and_belongs_to_many :orders

  enum state: [:active, :used_up, :inactive]

  validates :amount_remaining_in_cents, presence: true
  validate :user_didnt_create_promo!, if: :active?
  validate :doesnt_already_have_referral_promo!, :if => Proc.new { promo.type == "ReferralPromo" && !from_referral? }
  validates :promo_id, uniqueness: { scope: [:user_id] , message: "has already been applied" }, :if => Proc.new { promo.class != ReferralPromo || !from_referral? }

  scope :referral_promos, -> { joins(:promo).where(promos: { type: "ReferralPromo"} ) }

  before_validation on: :create do
    self.amount_remaining_in_cents = promo.discount_in_cents
    apply_promo_to_referrer!
  end

  def apply_promo_to_referrer!
    if promo.class == ReferralPromo

      if promo.user_id.present? && promo.user_id != user_id
        self.referrer = AppliedPromo.create!(state: :inactive, user_id: self.promo.user_id, promo_id: self.promo_id, from_referral: true)
      end

    end
  end

  after_create :expire_user_cache!

  def expire_user_cache!
    self.user.try(:touch)
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

    def doesnt_already_have_referral_promo!
      if user.promos.referral.where.not(user_id: user.id).count > 0
        self.errors.add(:base, "Only one referral code can be applied to an account")
      end
    end

end
