json.(food, :id, :title, :description, :goal)

json.end_date food.end_date.iso8601
json.state_id food.state
json.price (food.price_in_cents.to_f / 100.0)
json.header_image_url image_url(food.preview.url)
json.thumbnail_image_url image_url(food.preview.url)
json.order_count food.orders.active.count

# Ratings default to 4. Because we're scummy.
json.rating food.orders.average(:rating) || 4

json.seller do
  json.partial!("sellers/seller", seller: food.seller) if food.seller.present?
end

# Avoid infinite rendering loop of places rendering foods, and foods rendering places
if show_places ||= false
  json.places do
    json.array!(food.places, partial: "places/place", as: :place)
  end
end
