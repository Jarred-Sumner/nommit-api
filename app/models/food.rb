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
  enum state: { ready: 0, active: 1, ended: 2 }
  scope :visible, lambda { where("end_date > ?", DateTime.now) }
  validates :goal, presence: true

  scope :ongoing, lambda { where("end_date > ?", DateTime.now).where(state: "active") }
end
