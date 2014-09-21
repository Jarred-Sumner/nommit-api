json.(order, :id, :quantity, :created_at, :price_in_cents, :delivered_at, :rating)

json.state_id order.state

json.charge_state_id order.charge.try(:state)

json.address do
  json.partial!("addresses/address", address: order.address)
end

json.food do
  json.partial!("foods/food", food: order.food)
end

json.user do
  json.partial!("users/user", user: order.user)
end
