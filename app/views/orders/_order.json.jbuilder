json.(order, :id, :quantity, :price_in_cents, :tip_in_cents)

json.rating order.rating.to_f

json.delivered_at order.delivered_at.try(:iso8601)
json.created_at order.created_at.iso8601

json.state_id order.state_id
json.charge_state_id order.charge.try(:state_id) || Charge.states[:not_charged]

json.promo_code order.promo.try(:name)
json.discount_in_cents order.discount_in_cents

json.place do
  json.partial!(order.place, hide_delivery_places: true) if order.place.present?
end

json.food do
  json.partial!(order.food, hide_delivery_places: true) if order.food.present?
end

json.user do
  json.partial!(order.user) if order.user.present?
end

json.courier do
  json.partial!(order.courier) if order.courier.present?
end
