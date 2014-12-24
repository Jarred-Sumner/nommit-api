json.(shift, :id, :state_id)

json.revenue_generated_in_cents shift.orders.completed.joins(:price).sum("prices.price_in_cents")

json.courier do
  json.partial! shift.courier, show_seller: true
end

json.orders do
  json.array! shift.orders.pending, partial: "api/v1/orders/order", as: :order
end

json.place_ids do
  json.array! shift.places.pluck(:id)
end