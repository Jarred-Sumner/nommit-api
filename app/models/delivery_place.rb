class DeliveryPlace < ActiveRecord::Base
  belongs_to :shift
  belongs_to :place
  has_many :deliveries
  has_many :foods, through: :deliveries
  has_many :orders, through: :deliveries
  has_one :courier, through: :shift
  has_one :seller, through: :courier

  include StateID
  enum state: [:ready, :arrived, :halted, :ended]
  scope :active, lambda { where("state = ? OR state = ?", DeliveryPlace.states[:ready], DeliveryPlace.states[:arrived]) }

  validates :shift, presence: true
  validates :place, presence: true, uniqueness: { scope: :shift_id }
  validates :state, uniqueness: { scope: :shift_id }, if: :arrived?

  validates :current_index, presence: true, uniqueness: { :scope => [:shift_id, :place_id] }
  validates :start_index, presence: true, uniqueness: { :scope => [:shift_id, :place_id] }

  before_validation on: :create do
    self.start_index = current_index
  end

end
