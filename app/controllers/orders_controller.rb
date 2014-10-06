class OrdersController < ApplicationController
  before_action :require_active_delivery!, on: :create

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
    @order.food.ended! if @order.food.remaining.zero?
    render action: :show
  rescue ActiveRecord::RecordInvalid => e
    render_error(status: :bad_request, text: e.record.errors.full_messages.first)
  end

  def update
    if Integer(update_params[:state_id]) == Order.states[:rated]

      @order = Order.find_by(user_id: current_user.id, id: update_params[:id])
      return if @order.nil? || @order.rated?

      rating = Float(update_params[:rating])
      tip    = Integer(update_params[:tip_in_cents])
      @order.update_attributes!(state: Order.states[:rated], rating: rating, tip_in_cents: tip)
      # TODO charge them tip.
    elsif Integer(update_params[:state_id]) == Order.states[:delivered]
      @order = Order.find_by(courier: current_user.couriers, id: update_params[:id])
      return if @order.nil? || @order.delivered?

      @order.update_attributes!(state: Order.states[:delivered])
    end
    render action: :show
  end

  private

    def place
      @place ||= Place.find_by(id: params[:place_id])
    end

    def order_params
      params.require(:food_id)
      params.require(:place_id)
      params.permit(:food_id, :place_id, :quantity)
    end

    def update_params
      params.require(:id)
      params.permit(:state_id, :rating, :tip_in_cents, :id)
    end

    def shift
      @shift ||= Shift.find_by(courier: current_user.couriers, id: params[:shift_id])
    end

    def promo
      @promo ||= Promo.where(name: params[:promo_code]).first! if params[:promo_code].present?
    rescue ActiveRecord::RecordNotFound
      render_error(status: :bad_request, text: "Oops! Promo code not found. Try re-entering it?")
    end

    def delivery
      @delivery ||= Delivery.for(food_id: order_params[:food_id], place_id: order_params[:place_id]).first
    end

    def require_active_delivery!
      render_bad_request("Nobody is delivering this to #{place.name} right now. Please try again in a few minutes.") unless delivery.try(:active?)
    end
end
