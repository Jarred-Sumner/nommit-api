class Promo < ActiveRecord::Base
  has_many :orders
  has_many :user_promos
  scope :active, -> { where("expiration IS NULL OR expiration > ?", DateTime.now) }

  def usable_for?(user: nil)
    return false unless self.active?
    return false if self.orders.where(user_id: user.try(:id)).placed.count > 0
    true
  end

  def active?
    self.expiration.nil? || self.expiration.future?
  end

  validates :name, presence: true, uniqueness: true
  validates :discount_in_cents, presence: true
end
