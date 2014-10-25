json.(promo, :name, :discount_in_cents)

json.active promo.active?
json.referral promo.type == "ReferralPromo"
json.usable @current_user.present? ? promo.usable_for?(user: @current_user) : false
json.expiration promo.expiration
