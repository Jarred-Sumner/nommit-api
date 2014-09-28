json.id user.facebook_uid
json.(user, :email, :phone, :name, :last_signin, :created_at, :updated_at)

json.referral_code user.promo.name
json.referral_credit 0.0

json.is_courier user.couriers.count > 0

json.last_four user.payment_method.try(:last_four)
json.card_type user.payment_method.try(:card_type)
json.payment_authorized user.payment_method.try(:active?) == true
