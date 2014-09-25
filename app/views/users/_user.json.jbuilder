json.id user.facebook_uid
json.(user, :email, :phone, :name, :last_signin, :created_at, :updated_at)

json.referral_code user.promo.name

json.is_courier user.couriers.present?

# TODO
json.referral_credit 0
