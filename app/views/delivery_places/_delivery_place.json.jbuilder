json.(delivery_place, :id, :state_id)

json.index delivery_place.current_index
json.arrives_at delivery_place.arrives_at.iso8601
json.place do
  json.partial!(delivery_place.place)
end

if show_foods ||= false
  json.foods do
    json.array!(delivery_place.foods, partial: "foods/food", as: :food)
  end
end
