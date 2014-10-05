class PromosController < ApplicationController
  before_action :require_promo!

  def create
    if promo.usable_for?(user: current_user)
      current_user.user_promos.create!(promo_id: promo.id)
    else
      return render_bad_request("Promo code already in use or unavailable")
    end
    render current_user
  end

  private

    def promo
      @promo ||= Promo.active.find_by(name: create_params)
    end

    def require_promo!
      render_bad_request("Promo code not found or expired. Please re-enter it and try again.") if promo.nil?
    end

    def create_params
      params.require(:code)
    end

end
