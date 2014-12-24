json.cache! food do
  json.(food, :id, :title, :description, :goal)

  json.start_date food.start_date.try(:iso8601)
  json.end_date food.end_date.try(:iso8601)
  json.state_id food.state_id

  json.prices do
    json.array!(food.prices.order("quantity ASC"), partial: "api/v1/prices/price", as: :price)
  end

  json.header_image_url image_url(food.preview.url)
  json.thumbnail_image_url image_url(food.preview(:normal))

  json.order_count food.goal - food.sold

  # Ratings default to 4. Because we want people to buy the food.
  json.rating food.seller.rating

  # Until we update the API, we're just going to say that the seller is the restaurant
  if food.restaurant.present?
    json.seller do
      json.partial! food.restaurant
    end
  elsif food.seller.present?
    json.seller do
      json.partial! food.seller
    end
  end

  if !hide_delivery_places ||= false
    json.delivery_places do
      json.array!(food.delivery_places, partial: "api/v1/delivery_places/delivery_place", as: :delivery_place, show_places: true)
    end
  end
end