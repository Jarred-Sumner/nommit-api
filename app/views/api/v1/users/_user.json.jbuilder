json.id user.facebook_uid
json.(user, :email, :phone, :last_signin, :created_at, :updated_at, :state_id)

json.full_name user.name
json.name user.first_name
json.referral_code user.promo.name
json.credit_in_cents user.user_promos.active.sum(:amount_remaining_in_cents)

json.is_courier user.couriers.count > 0

json.last_four String(user.payment_method.try(:last_four))
json.card_type user.payment_method.try(:card_type)
json.payment_authorized user.payment_method.try(:active?) == true
