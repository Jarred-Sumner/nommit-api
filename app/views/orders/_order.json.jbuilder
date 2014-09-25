json.(order, :id, :quantity, :created_at, :price_in_cents, :delivered_at, :rating)

json.state_id order.state

json.charge_state_id order.charge.try(:state) || Charge::STATES[:not_charged]

json.promo_code order.promo.try(:name)
json.discount_in_cents order.promo.try(:discount_in_cents) || 0

json.place do
  json.partial!(order.place)
end

json.food do
  json.partial!("foods/food", food: order.food)
end

json.user do
  json.partial!("users/user", user: order.user)
end
