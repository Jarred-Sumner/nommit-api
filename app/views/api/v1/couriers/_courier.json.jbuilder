json.(courier, :state_id, :id)

if show_seller ||= false
  json.seller do
    json.partial!(partial: "api/v1/sellers/seller", locals: { seller: courier.seller })
  end
end

if show_places ||= false
  json.places do
    json.array!(courier.places)
  end
end

if show_shifts ||= false
  json.shifts do
    json.array!(courier.shifts)
  end
end

json.user do
  json.partial!(partial: "api/v1//users/user", locals: { user: courier.user })
end
