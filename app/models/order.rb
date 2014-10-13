class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user
  belongs_to :place
  belongs_to :courier
  belongs_to :delivery
  belongs_to :price
  has_one :charge
  has_and_belongs_to_many :applied_promos

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

  def price_in_cents
    price.price_in_cents
  end

  def quantity
    price.quantity
  end

  # Estimates work like this:
  # Sellers have some couriers.
  # Couriers delivery to Places (CourierPlace) in a rotation.
  # 5 minutes at Mudge, 5 minutes at Donner, etc.
  # Delivery estimates are based on the next time a Courier assigned to the Order's Place (through CourierPlace) is estimated to arrive.
  def delivery_estimate
  end

  before_validation on: :create do
    set_delivery!
  end
  after_create :apply_pending_promotions!, :issue_referral_credit!

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
      if self.delivery = Delivery.for(place_id: self.place_id, food_id: food_id).first
        set_courier!

        if delivery.delivery_place.arrived?
          self.state = :arrived
        end

      else
        errors.add(:base, "No couriers available to deliver to this location right now.")
      end
    end


    def set_courier!
      self.courier_id = delivery.delivery_place.shift.courier_id
    end

    def enough_food_is_left!
      if food.remaining - quantity < 0
        errors.add(:base, "Not enough food left to place that order")
      end
    end

    def set_delivery_estimate!
      self.delivered_at = delivery.delivery_place.arrives_at
    end

    def ensure_user_has_activated!
      self.errors.add(:base, "Please confirm your phone number before placing an order") if user.registered?
    end

    def delivery_place_is_accepting_new_orders!
      self.errors.add(:base, "No couriers available to fulfill this order - check back soon!") unless delivery.try(:active?)
    end

    def price_belongs_to_food!
      self.errors.add(:price, "is unavailable for this food") unless price.food_id == food_id
    end

    def apply_pending_promotions!
      user.applied_promos.active.order("created_at ASC").find_each do |u_p|
        promo = u_p.reload

        unless promo.usable?
          promo.inactive!
          next
        end

        # Free order?
        if promo.amount_remaining_in_cents >= price_in_cents - discount_in_cents
          promo.amount_remaining_in_cents = promo.amount_remaining_in_cents - price_in_cents - discount_in_cents
          self.discount_in_cents = price_in_cents
        else
          self.discount_in_cents = discount_in_cents + promo.amount_remaining_in_cents
          promo.amount_remaining_in_cents = 0
        end

        promo.state = :used_up if promo.amount_remaining_in_cents.zero?
        promo.save!
        promo.referrer.active! if promo.referrer.present? && promo.referrer.state != 'used_up'

        self.applied_promos << promo
        break if discount_in_cents >= price_in_cents
      end

      self.save!
    end

    def issue_referral_credit!
      self.applied_promos
    end

  validates :food, presence: true
  validates :user, presence: true
  validates :place, presence: true
  validates :courier, presence: true
  validates :delivery_id, presence: true
  validates :price, presence: true
  validate :price_belongs_to_food!

  validates :rating, inclusion: 1..5, allow_nil: true
  validates :rating, presence: true, if: :rated?
  validates :state, presence: true

  validate :food_is_active!, on: :create
  validate :delivery_place_is_accepting_new_orders!, on: :create
  validate :enough_food_is_left!, on: :create
  validate :ensure_user_has_activated!, on: :create
  validate :require_payment_method!, on: :create


end
