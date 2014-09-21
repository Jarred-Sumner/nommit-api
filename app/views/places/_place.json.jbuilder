json.(place, :name)

json.location do
  json.partial!(place.location)
end

# Avoid infinite rendering loop of foods rendering places, and places rendering foods
if show_foods ||= false
  json.foods do
    json.array!(place.foods, partial: 'foods/food', as: :food)
  end
end
