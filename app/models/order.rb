class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user
  belongs_to :place
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

  private

    def food_is_active!
      errors.add(:food, "must be orderable") unless food.active?
    end

  validates :food, presence: true
  validates :user, presence: true
  validates :place, presence: true

  validates :rating, inclusion: 1..5, allow_nil: true, if: -> { state == STATES[:delivered] }
  validates :state, inclusion: STATES.values.min..STATES.values.max, allow_nil: false

  validate :food_is_active!
end
