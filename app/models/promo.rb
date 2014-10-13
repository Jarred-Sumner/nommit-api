class Promo < ActiveRecord::Base
  has_many :user_promos
  has_many :orders, through: :user_promos
  scope :active, -> { where("expiration IS NULL OR expiration > ?", DateTime.now) }

  def usable_for?(user: nil)
    return false unless self.active?
    return false unless orders.where(user_id: user.id).count.zero?
    true
  end

  def active?
    self.expiration.nil? || self.expiration.future?
  end

  validates :name, presence: true, uniqueness: true
  validates :discount_in_cents, presence: true
end
