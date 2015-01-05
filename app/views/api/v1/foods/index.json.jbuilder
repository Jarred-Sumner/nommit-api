json.cache! @foods do
  json.array! @foods, partial: 'api/v1/foods/food', as: :food, show_places: true
end