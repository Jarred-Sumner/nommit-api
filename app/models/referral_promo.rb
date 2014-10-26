class ReferralPromo < Promo
  REFERRAL_DISCOUNT = 500.freeze unless defined?(REFERRAL_DISCOUNT)
  belongs_to :user
  validates :user, presence: true, uniqueness: true

  def usable_for?(user: nil)
    return false if self.user.id == user.id
    return false if user.orders.placed.count > 0
    return false if user.applied_promos.referral_promos.where.not(promos: { user_id: user.id }).count > 1
    super
  end

  before_validation :generate_name!, on: :create
  def generate_name!
    loop do
      initials = self.user.name.split(" ").collect { |name| name[0] }.join("")
      self.name = "#{initials}#{rand(1..999)}"
      break if Promo.where(name: name).empty?
    end
  end

  before_validation on: :create do
    self.discount_in_cents = REFERRAL_DISCOUNT
  end

end
