json.(order, :id, :quantity, :created_at, :price_in_cents, :rating)

json.delivered_at order.delivery.try(:created_at)

json.state_id order.state_id
json.charge_state_id order.charge.try(:state_id) || Charge.states[:not_charged]

json.promo_code order.promo.try(:name)
json.discount_in_cents order.promo.try(:discount_in_cents) || 0

json.place do
  json.partial!(order.place)
end

json.food do
  json.partial!(order.food)
end

json.user do
  json.partial!(order.user)
end

json.courier do
  json.partial!(order.courier)
end
