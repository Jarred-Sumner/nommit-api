class Charge < ActiveRecord::Base
  belongs_to :order
  belongs_to :payment_method

  include StateID
  enum state: { failed: -1, not_charged: 0, charged: 1, paid: 2, refunded: 3 }

  # TODO
  def charge

  end

  before_validation on: :create do
    self.state = Charge.states[:not_charged]
  end

  validates :state, inclusion: STATES.values.min..STATES.values.max, allow_nil: false
  validates :order, presence: true
  validates :payment_method, presence: true
end
