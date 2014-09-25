class Promo < ActiveRecord::Base
  has_many :orders

  def usable_for?(user: nil)
    self.orders.where(user_id: user.try(:id)).count.zero? && self.active?
  end

  def active?
    self.expiration.nil? || self.expiration.future?
  end

  validates :name, presence: true, uniqueness: true
  validates :discount_in_cents, presence: true
end
