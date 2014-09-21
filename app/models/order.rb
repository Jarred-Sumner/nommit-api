class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user
  belongs_to :location
  has_one :charge

  scope :active, -> { where.not(state: STATES[:cancelled]) }

  STATES = {
    cancelled: -1,
    placed: 0,
    delivering: 1,
    delivered: 2
  }

  def price
    self.price_in_cents / 100.0
  end

  after_create :set_location_to_users_default!

  private

    def set_location_to_users_default!
      self.user.update_attributes(:location_id => self.location_id)
    end

    def food_is_active!
      errors.add(:food, "must be orderable") unless food.active?
    end

  validates :food, presence: true
  validates :user, presence: true
  validates :location, presence: true

  validates :rating, inclusion: 1..5, allow_nil: true, if: -> { state == STATES[:delivered] }
  validates :state, inclusion: STATES.values.min..STATES.values.max, allow_nil: false

  validate :food_is_active!
end
