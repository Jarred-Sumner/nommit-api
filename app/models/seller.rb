class Seller < ActiveRecord::Base
  has_attached_file :logo, styles: { normal: "180x180" }
  
  has_many :base_foods
  has_many :foods
  has_many :sellable_foods

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

  def customer_satisfaction
    rating = orders.rated.where("rating > 4.5").count.to_f / orders.rated.count.to_f
    rating = rating * 100.0
    rating.round(2)
  end

  def revenue
    PayoutCalculator.new(orders.completed.pluck(:id)).revenue
  end

end
