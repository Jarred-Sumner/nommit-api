json.(delivery_place, :id)

json.index delivery_place.current_index
json.arrives_at delivery_place.arrives_at.try(:iso8601)

if !hide_place ||= false

  json.place do
    json.partial!(delivery_place.place)
  end

end

if show_foods ||= false
  json.foods do
    json.array!(delivery_place.foods, partial: "api/v1/foods/food", as: :food, hide_delivery_places: true)
  end
end

# Hack for backwards compatiblity with new state ID for iOS app.
if @for_orders_page
  json.state_id delivery_place.buyer_state_id
else
  json.state_id delivery_place.state_id
end
