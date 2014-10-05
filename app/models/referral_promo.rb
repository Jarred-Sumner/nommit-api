class ReferralPromo < Promo
  belongs_to :user
  validates :user, presence: true, uniqueness: true

  def usable_for?(user: nil)
    return false if user.orders.placed.count > 0
    super
  end

  before_validation :generate_name!, on: :create
  def generate_name!
    loop do
      initials = self.user.name.split(" ").collect { |name| name[0] }.join("")
      self.name = "#{initials}#{rand(1..999)}"
      break if Promo.where(name: self.name).empty?
    end
  end

end
