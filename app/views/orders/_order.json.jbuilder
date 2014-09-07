json.(order, :id :quantity, :price_in_cents, :created_at, :state)

json.address json.partial!("addresses/address", address: order.address)
json.food json.partial!("foods/food", food: order.food)
json.user json.partial!("users/user", user: order.user)
