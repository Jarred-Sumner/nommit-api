json.cache! food do
  json.(food, :id, :title, :description, :goal, :featured)

  json.start_date food.start_date.try(:iso8601)
  json.end_date food.end_date.try(:iso8601)
  json.state_id food.try(:state_id)

  json.prices do
    json.array!(food.prices.order("quantity ASC"), partial: "api/v1/prices/price", as: :price)
  end

  json.header_image_url image_url(food.preview.url)
  json.thumbnail_image_url image_url(food.preview(:normal))

  json.order_count food.try(:remaining)

  # Ratings default to 4. Because we want people to buy the food.
  json.rating food.seller.rating

  json.seller do
    json.partial! food.seller
  end

end