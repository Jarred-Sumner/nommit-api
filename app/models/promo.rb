class Promo < ActiveRecord::Base
  has_many :applied_promos
  has_many :orders, through: :applied_promos
  scope :active, -> { where("expiration IS NULL OR expiration > ?", DateTime.now) }

  def usable_for?(user: nil)
    return false unless active?
    return false unless applied_promos.where(user_id: user.id).count.zero?
    return false unless orders.where(user_id: user.id).count.zero?
    true
  end

  def active?
    expiration.nil? || expiration.future?
  end

  validates :name, presence: true, uniqueness: true
  validates :discount_in_cents, presence: true
end
