class Courier < ActiveRecord::Base
  belongs_to :user
  belongs_to :seller
  has_many :shifts
  has_many :places, -> { uniq },  through: :shifts
  has_many :deliveries

  enum state: { inactive: 0, active: 1 }
  include StateID
end
