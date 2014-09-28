json.(place, :name, :id)

json.location do
  json.partial!(place.location)
end

json.food_count place.foods.active.count

if show_foods ||= false
  json.array! place.food_delivery_places
end
