class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user
  belongs_to :place
  belongs_to :promo
  belongs_to :courier
  belongs_to :delivery
  has_one :charge
  include StateID
  enum state: { cancelled: -1, active: 0, arrived: 1, delivered: 2, rated: 3 }

  def price
    self.price_in_cents / 100.0
  end

  # Estimates work like this:
  # Sellers have some couriers.
  # Couriers delivery to Places (CourierPlace) in a rotation.
  # 5 minutes at Mudge, 5 minutes at Donner, etc.
  # Delivery estimates are based on the next time a Courier assigned to the Order's Place (through CourierPlace) is estimated to arrive.
  def delivery_estimate
  end

  before_validation on: :create do
    set_price_in_cents!
    set_promo_discount! if promo.present?
    set_delivery!
    set_courier!
    set_delivery_estimate!
    binding.pry
    self.original_delivered_at = self.delivered_at
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

    def delivery_place_is_active!
      errors.add(:base, "No couriers available to deliver to this location right now.") if !delivery.delivery_place.arrived? && !delivery.delivery_place.ready?
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

    def set_delivery!
      self.delivery_id = Delivery.where(food_id: self.food_id)
        .joins(:delivery_place)
        .where(delivery_places: { place_id: place.id })
        .select("deliveries.id")
        .first
        .id

      if self.delivery.delivery_place.arrived?
        self.arrived!
      end
    end

    def set_delivery_estimate!
      self.delivered_at = self.delivery.delivery_place.arrives_at
    end

    def set_courier!
      self.courier_id = self.delivery.delivery_place.shift.courier_id
    end

  validates :food, presence: true
  validates :user, presence: true
  validates :place, presence: true
  validates :courier, presence: true

  validates :rating, inclusion: 1..5, allow_nil: true
  validates :rating, presence: true, if: :rated?
  validates :state, presence: true

  validate :food_is_active!
  validate :delivery_place_is_active!, on: :create


end
