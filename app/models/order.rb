class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user
  belongs_to :place
  belongs_to :promo
  belongs_to :courier
  belongs_to :delivery
  has_one :charge
  has_and_belongs_to_many :user_promos
  include StateID
  enum state: { cancelled: -1, active: 0, arrived: 1, delivered: 2, rated: 3 }

  scope :placed, -> do
    states = [
      Order.states[:active],
      Order.states[:arrived],
      Order.states[:delivered],
      Order.states[:rated]
    ]
    where(state: states)
  end

  scope :pending, -> do
    states = [
      Order.states[:active],
      Order.states[:arrived]
    ]
    where(state: states)
  end

  scope :completed, -> do
    states = [
      Order.states[:delivered],
      Order.states[:rated]
    ]
    where(state: states)
  end

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
    set_delivery!
    set_promo_discount! if promo.present?
  end
  after_create :apply_pending_promotions!

  private

    def require_payment_method!
      unless user.payment_method.try(:active?)
        errors.add(:payment_method, "isn't working - could you re-enter it?")
      end
    end

    def food_is_active!
      errors.add(:food, "doesn't have couriers delivering right now. Try again in a few minutes!") unless food.active?
    end

    def set_delivery!
      if self.delivery = Delivery.for(place_id: self.place_id, food_id: self.food_id).first
        set_courier!

        if self.delivery.delivery_place.arrived?
          self.state = :arrived
        end

      else
        errors.add(:base, "No couriers available to deliver to this location right now.")
      end
    end


    def set_courier!
      self.courier_id = self.delivery.delivery_place.shift.courier_id
    end

    def enough_food_is_left!
      if self.food.remaining - self.quantity < 0
        errors.add(:base, "Not enough food left to place that order")
      end
    end

    def set_price_in_cents!
      self.price_in_cents = food.price_in_cents * self.quantity
    end

    def set_promo_discount!
      if self.promo.usable_for?(user: self.user)
        self.discount_in_cents = promo.discount_in_cents
      else
        errors.add(:promo, "has expired or has already been used")
      end
    end

    def set_delivery_estimate!
      self.delivered_at = self.delivery.delivery_place.arrives_at
    end

    def ensure_user_has_activated!
      self.errors.add(:base, "Please confirm your phone number before placing an order") if user.registered?
    end

    def delivery_place_is_accepting_new_orders!
      self.errors.add(:base, "No couriers available to fulfill this order - check back soon!") unless delivery.try(:active?)
    end

    def apply_pending_promotions!

      # self.user.user_promos.active.collect do |user_promo|
      #   promo = user_promo.reload
      #   self.discount_in_cents = price_in_cents - self.discount_in_cents - promo.amount_remaining_in_cents
      #
      #
      #   promo.amount_remaining_in_cents = user_promo.amount_remaining_in_cents - self.price_in_cents
      #   promo.state = :used_up if promo.amount_remaining_in_cents.zero?
      #   promo.save!
      #
      #   self.discount_in_cents = price_in_cents if self.discount_in_cents > price_in_cents
      #   self.user_promos << promo
      #
      #   break if self.discount_in_cents >= self.price_in_cents
      # end
      #
      # self.save!

    end

  validates :food, presence: true
  validates :user, presence: true
  validates :place, presence: true
  validates :courier, presence: true
  validates :delivery_id, presence: true

  validates :rating, inclusion: 1..5, allow_nil: true
  validates :rating, presence: true, if: :rated?
  validates :state, presence: true

  validate :food_is_active!, on: :create
  validate :delivery_place_is_accepting_new_orders!, on: :create
  validate :enough_food_is_left!, on: :create
  validate :ensure_user_has_activated!, on: :create
  validate :require_payment_method!, on: :create


end
