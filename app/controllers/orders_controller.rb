class OrdersController < ApplicationController

  def index
    @orders = Order.where(user: current_user)
  end

  def show
    @order = Order.find_by(user: current_user, id: params[:id])
  end

  def create
    @order = Order.create!(order_params.merge(user_id: current_user.id, promo_id: promo.try(:id)))
    render action: :show
  rescue ActiveRecord::RecordInvalid => e
    render_error(status: :bad_request, text: e.record.errors.full_messages.first)
  end

  private

    def order_params
      params.permit(:food_id, :place_id, :quantity)
    end

    def promo
      @promo ||= Promo.where(name: params[:promo_code]).first! if params[:promo_code].present?
    rescue ActiveRecord::RecordNotFound
      render_error(status: :bad_request, text: "Oops! Promo code not found. Try re-entering it?")
    end

end
