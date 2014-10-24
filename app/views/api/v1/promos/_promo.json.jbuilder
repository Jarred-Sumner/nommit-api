json.(promo, :name)

json.active promo.active?
json.usable @current_user.present? ? promo.usable_for?(user: @current_user) : false
