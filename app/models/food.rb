class Food < ActiveRecord::Base
  has_attached_file :preview#, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :preview, :content_type => /\Aimage\/.*\Z/
  has_many :orders
  has_many :deliveries
  has_many :shifts, source: :seller
  has_many :delivery_places, through: :deliveries
  has_many :places, lambda { uniq }, through: :delivery_places
  has_many :couriers, through: :shifts
  belongs_to :seller

  include StateID
  enum state: { active: 0, halted: 1, ended: 2 }
  scope :visible, lambda { where("end_date > ?", DateTime.now) }

  scope :orderable, -> do
    active.visible
  end

  validates :title, presence: true
  validates :description, presence: true
  validates :goal, presence: true
  validates :price_in_cents, presence: true, numericality: { only_integer: true, greater_than: 99 }
  validates :seller_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :ongoing, lambda { where("? BETWEEN start_date AND end_date", DateTime.now).where(state: "active") }

  def remaining
    self.goal - self.orders.placed.sum(:quantity)
  end
end
