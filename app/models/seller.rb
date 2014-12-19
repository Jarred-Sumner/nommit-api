class Seller < ActiveRecord::Base
  has_attached_file :logo
  has_many :foods
  has_many :couriers
  has_many :places, through: :foods
  has_many :orders, through: :foods
  has_many :shifts
  has_many :delivery_places
  belongs_to :school

  validates_attachment :logo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

  def rating
    orders.rated.average(:rating).to_f || 4.0
  end
end
