class Charge < ActiveRecord::Base
  belongs_to :order
  belongs_to :payment_method

  STATES = {
    failed: -1,
    not_charged: 0,
    charged: 1,
    succeeded: 2,
  }

  # TODO
  def charge
  end

  before_validation on: :create do
    self.state ||= STATES[:not_charged]
  end

  validates :state, inclusion: STATES.values.min..STATES.values.max, allow_nil: false
  validates :order, presence: true
  validates :payment_method, presence: true
end
