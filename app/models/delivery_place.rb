class DeliveryPlace < ActiveRecord::Base
  belongs_to :shift
  belongs_to :place
  has_many :deliveries
  has_many :foods, through: :deliveries
  has_many :orders, through: :deliveries
  include StateID
  enum state: [:ready, :arrived, :ended]
  scope :active, lambda { where("state = ? OR state = ?", DeliveryPlace.states[:ready], DeliveryPlace.states[:arrived]) }

  validates :shift, presence: true
  validates :place, presence: true, uniqueness: { scope: :shift }
  validates :state, uniqueness: { scope: :shift }, if: :arrived?

  validates :current_index, presence: true, uniqueness: { :scope => [:shift, :place] }
  validates :start_index, presence: true, uniqueness: { :scope => [:shift, :place] }

  before_validation on: :create do
    self.start_index = current_index
  end

end
