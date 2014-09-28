json.(fdp, :id, :state_id, :index, :wait_interval)

json.place do
  json.partial! fdp.place, show_foods: show_foods ||= false
end

json.food do
  json.partial! fdp.food, show_places: show_places ||= false
end

if show_courier ||= false
  json.courier do
    json.partial! fdp.courier
  end
end
