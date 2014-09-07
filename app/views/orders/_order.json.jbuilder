json.(order, :id, :quantity, :created_at, :state)

json.price order.price * 100

json.address do
  json.partial!("addresses/address", address: order.address)
end

json.food do
  json.partial!("foods/food", food: order.food)
end

json.user do
  json.partial!("users/user", user: order.user)
end
