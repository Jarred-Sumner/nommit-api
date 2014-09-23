json.(location, :name, :id, :phone, :address_one, :address_two, :city, :state, :zip, :country, :instructions, :created_at, :updated_at)

json.latitude location.latitude.to_f
json.longitude location.longitude.to_f
