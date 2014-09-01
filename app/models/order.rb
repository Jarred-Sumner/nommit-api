class Order < ActiveRecord::Base
  belongs_to :food
  belongs_to :user

  has_one :address, as: :addressable

  STATES = {
    placed: 0,
    delivering: 1,
    delivered: 2
  }

  after_create :set_address_to_users_default!

  private

    def set_address_to_users_default!
      user_address = self.address.dup
      user_address.addressable = user
      user_address.save!
    end

    def food_is_active!
      errors.add(:food, "must be orderable") unless food.active?
    end

  validates :food, presence: true
  validates :user, presence: true

  validate :food_is_active!
end
