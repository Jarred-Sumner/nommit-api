json.(fdp, :id, :state_id, :index, :wait_interval)

json.place do
  json.partial! partial: "/places/place", locals: { place: fdp.place, show_places: show_places ||= false }
end

json.food do
  json.partial! partial: "/foods/food", locals: { food: fdp.food, show_foods: show_foods ||= false }
end

json.courier do
  json.partial! partial: "/couriers/courier", locals: { courier: fdp.courier }
end
