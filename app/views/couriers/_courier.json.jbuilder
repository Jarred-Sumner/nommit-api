json.(courier, :state_id, :id)

json.seller do
  json.partial!(courier.seller)
end

json.places do
  json.array!(courier.places)
end

json.user do
  json.partial!(courier.user)
end
