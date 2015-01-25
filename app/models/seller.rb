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
    rating.round(1)
  end

  def payout_calculator
    @payout_calculator ||= PayoutCalculator.new(orders.completed.pluck(:id))
  end

  def revenue
    payout_calculator.revenue
  end

  def late_rate
    orders.late.count.to_f / orders.placed.count.to_f
  end

end
