class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user
  belongs_to :place
  belongs_to :courier
  belongs_to :delivery
  belongs_to :price
  has_one :charge, dependent: :destroy
  has_one :seller, through: :food
  has_one :delivery_place, through: :delivery
  has_one :shift, through: :delivery_place
  has_and_belongs_to_many :applied_promos

  include StateID
  include TimingScopes

  enum state: { cancelled: -1, active: 0, arrived: 1, delivered: 2, rated: 3 }

  scope :placed, -> do
    where(state: placed_states)
  end

  scope :pending, -> do
    where(state: pending_states)
  end

  scope :completed, -> do
    where(state: completed_states)
  end

  scope :unhappy, -> do
    rated.where("rating < 4.5").order("rating ASC")
  end

  scope :satisfied, -> do
    ids = rated.where("rating > 4.5").order('rating DESC').pluck(:id)
    Order.where(id: ids)
  end

  scope :late, -> do
    placed.where("orders.delivered_at > (orders.created_at + INTERVAL '15 minute')")
  end

  def self.pending_states
    [
      Order.states[:active],
      Order.states[:arrived]
    ]
  end

  def self.completed_states
    [
      Order.states[:delivered],
      Order.states[:rated]
    ]
  end

  def self.placed_states
    pending_states.zip(completed_states)
  end

  def pending?
    self.class.pending_states.include? state_id
  end

  def completed?
    self.class.completed_states.include? state_id
  end

  def price_in_cents
    price.price_in_cents
  end

  def quantity
    price.quantity
  end

  def self.satisfaction_by_week
    satisfied = Order.satisfied.group_by_week(:created_at).count
    all = Order.rated.group_by_week(:created_at).count

    relative = Hash.new
    satisfied.each do |k, v|
      relative[k] = v.to_f / all[k].to_f
    end
    relative
  end

  def delivered!
    transaction do
      update_attributes!(state: "delivered", delivered_at: DateTime.now, original_delivered_at: delivered_at)
      shift.update_arrival_times!
    end
  end

  private

    def require_payment_method!
      unless user.payment_method.try(:active?)
        errors.add(:payment_method, "isn't working. To continue, please re-enter your payment information and try again.")
      end
    end

    def food_is_active!
      errors.add(:food, "doesn't have couriers delivering right now. Try again in a few minutes!") unless food.try(:active?)
    end

    def set_delivery!
      if self.delivery = Delivery.for(place_id: place_id, food_id: food_id).first
        set_courier!
      else
        errors.add(:base, "No couriers available to deliver to this location right now.")
      end
    end

    def set_estimate!
      self.delivered_at = 15.minutes.from_now
    end


    def set_courier!
      self.courier_id = delivery.delivery_place.shift.courier_id
    end

    def enough_food_is_left!
      if food.remaining - quantity < 0
        errors.add(:base, "Not enough food left to place that order")
      end
    end

    def ensure_user_has_activated!
      errors.add(:base, "Please confirm your phone number before placing an order") if user.registered?
    end

    def delivery_place_is_accepting_new_orders!
      errors.add(:base, "No couriers available to fulfill this order - check back soon!") unless delivery.try(:active?)
    end

    def food_is_being_sold!
      if food.start_date.future?
        errors.add(:base, "Food isn't being sold yet")
      elsif food.end_date.past?
        errors.add(:base, "Food is no longer being sold for tonight!")
      end
    end

    def price_belongs_to_food!
      errors.add(:price, "is unavailable for this food") unless price.try(:food_id) == food_id
    end

    def apply_pending_promotions!
      # Grab all the active pending promotions
      user.applied_promos.active.order("created_at ASC").find_each do |u_p|
        # Create a copy of it so it becomes mutable
        promo = u_p.reload

        # If the promo expired or otherwise is unusable for some reason (and wasn't marked as such), mark it unusable
        unless promo.usable?
          promo.inactive!
          next
        end

        # If we somehow have caused the promo to have a negative balance, and still marked it as active
        if promo.amount_remaining_in_cents <= 0
          promo.update_attributes!(amount_remaining_in_cents: 0, state: "used_up")
          next
        end

        # Free order?
        if promo.amount_remaining_in_cents > price_in_cents - discount_in_cents
          promo.amount_remaining_in_cents = promo.amount_remaining_in_cents - (price_in_cents - discount_in_cents)
          self.discount_in_cents = price_in_cents
        else
          self.discount_in_cents = discount_in_cents + promo.amount_remaining_in_cents
          promo.amount_remaining_in_cents = 0
        end

        promo.state = :used_up if promo.amount_remaining_in_cents.zero?
        promo.save!

        # Activate the referral credit of the referrer if it hasn't been all used up
        if promo.referrer.present? && promo.referrer.state != 'used_up'
          promo.referrer.active!
          activated_referrals << promo.id
        end

        applied_promos << promo
        break if discount_in_cents >= price_in_cents
      end

      save!

    end

    def ensure_courier_isnt_delivering_to_self!
      if seller.couriers.active.where(user_id: id).count > 0
        errors.add(:base, "Can't place orders to yourself!")
      end
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

  before_validation :set_delivery!, :set_estimate!, on: :create
  after_create do
    apply_pending_promotions!

    Charge.create!(order_id: self.id, payment_method_id: user.payment_method.id)
    ChargeWorker.perform_at(Charge::DELAY.hours.from_now, self.id)

    shift.update_arrival_times!

    # Let the courier know there's a new order pending delivery
    PushNotifications::Courier::DeliveryWorker.perform_async(id)

    # Send the courier a push notification 3 minutes before the order is set to arrive
    PushNotifications::Courier::HurryUpWorker.perform_at(delivered_at - 3.minutes, id)
  end

  validate :food_is_active!, on: :create
  validate :delivery_place_is_accepting_new_orders!, on: :create
  validate :ensure_courier_isnt_delivering_to_self!, on: :create
  validate :food_is_being_sold!, on: :create
  validate :enough_food_is_left!, on: :create
  validate :ensure_user_has_activated!, on: :create
  validate :require_payment_method!, on: :create

end
