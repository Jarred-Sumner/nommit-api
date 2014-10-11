json.(shift, :id, :state_id)

json.revenue_generated_in_cents shift.orders.completed.sum(:price_in_cents)

json.courier do
  json.partial! shift.courier, show_seller: true
end

json.delivery_places do
  json.array! shift.delivery_places, partial: "api/v1/delivery_places/delivery_place", as: :delivery_place
end
