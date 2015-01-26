json.(seller, :id, :name)

json.logo_url image_url(seller.logo(:normal))

json.school do
  json.partial! seller.school
end

