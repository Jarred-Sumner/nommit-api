json.(courier, :state_id, :id)

if show_seller ||= false
  json.seller do
    json.partial!(courier.seller)
  end
end

if show_places ||= false
  json.places do
    json.array!(courier.places)
  end
end

if show_food_delivery_places ||= false
  json.food_delivery_places do
    json.array!(courier.food_delivery_places)
  end
end

json.user do
  json.partial!(partial: "/users/user", locals: { user: courier.user })
end
