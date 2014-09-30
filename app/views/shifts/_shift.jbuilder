json.(shift, :id, :state_id)

json.courier do
  json.partial! shift.courier, show_seller: true
end
json.delivery_places do
  json.array! shift.delivery_places, partial: "delivery_places/delivery_place", as: :delivery_place
end
