json.(food, :id, :title, :place, :description, :state, :end_date, :goal)

json.price (food.price_in_cents.to_f / 100.0)
json.header_image_url food.preview.url
json.thumbnail_image_url food.preview.url
json.order_count food.orders.active.count
