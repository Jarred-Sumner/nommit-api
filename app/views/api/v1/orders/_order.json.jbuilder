json.(order, :id, :price_in_cents, :tip_in_cents)

json.quantity order.price.quantity
json.rating order.rating.to_f

json.delivered_at order.delivered_at.try(:iso8601)
json.created_at order.created_at.iso8601

json.state_id order.state_id
json.charge_state_id order.charge.try(:state_id) || Charge.states[:not_charged]
json.price_charged_in_cents order.price_in_cents - order.discount_in_cents

# Will remove in a later version of the API
# We no longer associate Order with Promo
json.promo_code nil
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
