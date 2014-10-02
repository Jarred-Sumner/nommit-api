json.(delivery_place, :id, :state_id)

json.index delivery_place.current_index
json.arrives_at delivery_place.arrives_at.iso8601

if !hide_place ||= false

  json.place do
    json.partial!(delivery_place.place)
  end

end

if show_foods ||= false
  json.foods do
    json.array!(delivery_place.foods, partial: "foods/food", as: :food, hide_delivery_places: true)
  end
end
