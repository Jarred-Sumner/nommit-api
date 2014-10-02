class OrdersController < ApplicationController

  def index
    if place.present?
      @orders = place.orders.where(courier: current_user.couriers.first)
    else
      @orders = Order.where(user: current_user)
    end
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

  def update
    if @order = Order.find_by(courier: current_user.couriers, id: update_params[:id])
      if Integer(update_params[:state_id]) == Order.states[:delivered]
        @order.update_attributes!(state: Order.states[:delivered])
      end
      render action: :show
    end

  end

  private

    def place
      @place ||= Place.find_by(id: params[:place_id])
    end

    def order_params
      params.permit(:food_id, :place_id, :quantity)
    end

    def update_params
      params.permit(:id, :state_id)
    end

    def shift
      @shift ||= Shift.find_by(courier: current_user.couriers, id: params[:shift_id])
    end

    def promo
      @promo ||= Promo.where(name: params[:promo_code]).first! if params[:promo_code].present?
    rescue ActiveRecord::RecordNotFound
      render_error(status: :bad_request, text: "Oops! Promo code not found. Try re-entering it?")
    end

end
