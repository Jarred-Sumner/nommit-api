class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user
  belongs_to :place
  belongs_to :promo
  has_one :charge
  has_one :delivery
  has_one :courier, through: :delivery

  include StateID
  enum state: { cancelled: -1, active: 0, delivering: 1, delivered: 2 }

  def price
    self.price_in_cents / 100.0
  end

  before_validation :on => :create do
    set_price_in_cents!
    set_promo_discount! if promo.present?
  end

  private

    def require_payment_method!
      unless user.payment_method.try(:active?)
        errors.add(:payment_method, "isn't working - could you re-enter it?")
      end
    end

    def food_is_active!
      errors.add(:food, "must be orderable") unless food.active?
    end

    def set_price_in_cents!
      self.price_in_cents = food.price_in_cents
    end

    def set_promo_discount!
      if self.promo.usable_for?(user: self.user)
        self.discount_in_cents = promo.discount_in_cents
      else
        errors.add(:promo, "has expired or has already been used")
      end
    end

  validates :food, presence: true
  validates :user, presence: true
  validates :place, presence: true

  validates :rating, inclusion: 1..5, allow_nil: true, if: -> { delivered? }
  validates :state, presence: true

  validate :food_is_active!


end
