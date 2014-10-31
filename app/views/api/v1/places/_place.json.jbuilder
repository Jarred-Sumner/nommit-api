json.(place, :name, :id)

json.location do
  json.partial!(partial: "api/v1/locations/location", locals: { location: place.location })
end

json.food_count place.food_count

if !hide_delivery_places ||= false
  json.delivery_places do
    json.array!(place.delivery_places.active, partial: "api/v1/delivery_places/delivery_place", as: :delivery_place, hide_place: true, show_foods: true)
  end
end
