json.(food, :id, :title, :place, :description, :end_date, :goal)

json.state_id food.state
json.price (food.price_in_cents.to_f / 100.0)
json.header_image_url image_url(food.preview.url)
json.thumbnail_image_url image_url(food.preview.url)
json.order_count food.orders.active.count
json.rating food.orders.average(:rating)

json.seller do
  json.partial!("sellers/seller", seller: food.seller)
end
