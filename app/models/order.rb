class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user
  belongs_to :address

  scope :active, -> { where(state: STATES[:placed]) }

  STATES = {
    placed: 0,
    delivering: 1,
    delivered: 2
  }

  def price
    self.price_in_cents * 100
  end

  after_create :set_address_to_users_default!

  private

    def set_address_to_users_default!
      self.user.update_attributes(:address_id => self.address_id)
    end

    def food_is_active!
      errors.add(:food, "must be orderable") unless food.active?
    end

  validates :food, presence: true
  validates :user, presence: true
  validates :address, presence: true

  validate :food_is_active!
end
