class SellableFood < BaseFood
  has_many :versions, class_name: Food, foreign_key: "parent_id"

  def version!(start_date: nil, end_date: nil, goal: nil)
    v = versions.create! do |food|
      food.start_date = start_date
      food.end_date = end_date
      food.goal = goal
      food.preview = open(preview.url) if preview?
      food.seller = seller
      food.restaurant = restaurant
      food.description = description
      food.title = title
      food.parent = self
    end

    prices.each do |price|
      v.prices.create!(price_in_cents: price.price_in_cents, quantity: price.quantity)
    end

  end

end