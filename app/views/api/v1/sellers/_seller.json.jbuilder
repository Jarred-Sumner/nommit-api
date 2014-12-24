json.cache! seller do
  json.(seller, :id, :name)

  json.logo_url image_url(seller.logo(:normal))
end