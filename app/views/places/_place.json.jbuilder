json.(place, :name, :id)

json.location do
  json.partial!(partial: "locations/location", locals: { location: place.location })
end

json.food_count place.food_count

if show_delivery_places ||= false
  json.delivery_places do
    json.array!(place.delivery_places, partial: "delivery_places/delivery_place", as: :delivery_place)
  end
end
