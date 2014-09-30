json.(order, :id, :quantity, :created_at, :price_in_cents, :rating)

json.delivered_at order.delivered_at || order.delivery_estimate

json.state_id order.state_id
json.charge_state_id order.charge.try(:state_id) || Charge.states[:not_charged]

json.promo_code order.promo.try(:name)
json.discount_in_cents order.promo.try(:discount_in_cents) || 0

json.place do
  json.partial!(order.place) if order.place.present?
end

json.food do
  json.partial!(order.food) if order.food.present?
end

json.user do
  json.partial!(order.user) if order.user.present?
end

json.courier do
  json.partial!(order.courier) if order.courier.present?
end
