class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user
  belongs_to :place
  belongs_to :promo
  belongs_to :courier
  has_one :charge
  include StateID
  enum state: { cancelled: -1, active: 0, delivered: 1 }

  def price
    self.price_in_cents / 100.0
  end

  def food_delivery_place
    @food_delivery_place = FoodDeliveryPlace.active.find_by(place: self.place, food: self.food)
  end

  # Estimates work like this:
  # Sellers have some couriers.
  # Couriers delivery to Places (CourierPlace) in a rotation.
  # 5 minutes at Mudge, 5 minutes at Donner, etc.
  # Delivery estimates are based on the next time a Courier assigned to the Order's Place (through CourierPlace) is estimated to arrive.
  def delivery_estimate
    food_delivery_place.eta
  end

  before_validation :on => :create do
    set_price_in_cents!
    set_promo_discount! if promo.present?
    set_courier!
  end

  private

    def require_payment_method!
      unless user.payment_method.try(:active?)
        errors.add(:payment_method, "isn't working - could you re-enter it?")
      end
    end

    def food_is_active!
      errors.add(:food, "doesn't have couriers delivering right now. Try again in a few minutes!") unless food.active?
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

    def set_courier!
      self.courier = food_delivery_place.courier
    end

  validates :food, presence: true
  validates :user, presence: true
  validates :place, presence: true
  validates :courier, presence: true

  validates :rating, inclusion: 1..5, allow_nil: true, if: -> { delivered? }
  validates :state, presence: true

  validate :food_is_active!


end
