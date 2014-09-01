json.foods do
  json.partial!('foods/food', collection: @foods, as: :food)
end
json.orders do
  json.partial! 'orders/order', collection: @orders, as: :order
end
json.user do
  json.partial! 'users/user', user: @current_user
end
