class UserPromo < ActiveRecord::Base
  belongs_to :user
  belongs_to :promo
  has_and_belongs_to_many :orders

  enum state: [:active, :used_up]

  validates :user_id, uniqueness: { scope: [:promo_id], message: "has already applied this promo" }
  validates :amount_remaining_in_cents, presence: true
  validate :user_didnt_create_promo!

  before_validation on: :create do
    self.amount_remaining_in_cents = promo.discount_in_cents
  end

  private

    def user_didnt_create_promo!
      self.errors.add(:base, "Can't use your own referral code") if self.promo.user_id == self.user_id
    end

end
