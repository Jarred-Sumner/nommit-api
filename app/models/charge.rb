class Charge < ActiveRecord::Base
  DELAY = 24 unless defined?(DELAY)
  belongs_to :order
  belongs_to :payment_method
  include TimingScopes

  include StateID
  enum state: { failed: -1, not_charged: 0, charged: 1, paid: 2, refunded: 3 }

  before_validation on: :create do
    self.state = Charge.states[:not_charged]
  end

  validates :state, presence: true
  validates :order, presence: true
  validates :payment_method, presence: true
end
