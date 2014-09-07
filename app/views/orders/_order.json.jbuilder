json.(order, :id, :food_id, :user_id, :quantity, :price_in_cents, :created_at, :state)

json.delivery_address order.address.address_one
json.delivery_instructions order.address.instructions
