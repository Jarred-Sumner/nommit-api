json.(food, :id, :title, :description, :goal)

json.end_date food.end_date.iso8601
json.state_id food.state_id
json.price (food.price_in_cents.to_f / 100.0)
json.header_image_url image_url(food.preview.url)
json.thumbnail_image_url image_url(food.preview.url)

# Teespring A/B tested this, and found that showing at least one order increased conversions
json.order_count food.orders.active.count + 1

# Ratings default to 4. Because we want people to buy the food.
json.rating food.orders.average(:rating).to_f || 4.to_f

json.seller do
  json.partial!("sellers/seller", seller: food.seller) if food.seller.present?
end

if !hide_delivery_places ||= false
  json.delivery_places do
    json.array!(food.delivery_places, partial: "delivery_places/delivery_place", as: :delivery_place, show_places: true)
  end
end
