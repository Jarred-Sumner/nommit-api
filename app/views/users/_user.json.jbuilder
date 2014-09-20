json.id user.facebook_uid
json.(user, :email, :phone, :name, :last_signin, :created_at, :updated_at)

json.seller do
  json.partial!("sellers/seller", seller: user.seller)
end
