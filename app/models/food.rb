class Food < ActiveRecord::Base
  has_attached_file :preview#, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :preview, :content_type => /\Aimage\/.*\Z/
  has_many :orders
  has_many :food_delivery_places
  has_many :places, through: :food_delivery_places
  has_many :couriers, through: :food_delivery_places
  belongs_to :seller

  include StateID
  enum state: { ready: 0, active: 1, ended: 2 }
  validates :goal, presence: true

  scope :ongoing, lambda { where("end_date > ?", DateTime.now).where(state: "active") }
end
