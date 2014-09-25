class ReferralPromo < Promo
  belongs_to :user
  validates :user, presence: true, uniqueness: true

  before_validation :generate_name!, on: :create
  def generate_name!
    loop do
      self.name = "#{self.user.name.gsub(' ', '-')}-#{rand(100..999)}"
      break if Promo.where(name: self.name).empty?
    end
  end

end
