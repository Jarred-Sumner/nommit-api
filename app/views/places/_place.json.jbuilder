json.(place, :name, :id)

json.location do
  json.partial!(place.location)
end

json.food_count place.foods.active.count

# Avoid infinite rendering loop of foods rendering places, and places rendering foods
if show_foods ||= false
  json.foods do
    json.array!(place.foods.ongoing, partial: 'foods/food', as: :food)
  end
end
