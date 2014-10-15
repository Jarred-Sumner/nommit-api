class Api::V1::OrdersController < Api::V1::ApplicationController
  before_action :apply_promo!, only: :create, if: -> { params[:promo_code].present? }

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
    @order = Order.create!(order_params.merge(user_id: current_user.id))
    @order.food.ended! if @order.food.remaining.zero?
    render action: :show
  rescue ActiveRecord::RecordInvalid => e
    render_error(status: :bad_request, text: e.record.errors.full_messages.first)
  end

  def update
    if Integer(update_params[:state_id]) == Order.states[:rated]
      @order = Order.find_by(user_id: current_user.id, id: update_params[:id])
      return render_not_found if @order.nil? || @order.rated? || !@order.delivered?

      if @order.charge.paid? && update_params[:tip_in_cents].present?
        return render_bad_request("Cannot tip an order 24 hours later -- your card has already been charged.")
      end

      rating = Float(update_params[:rating] || 4)
      tip    = Integer(update_params[:tip_in_cents] || 0)
      @order.update_attributes!(state: Order.states[:rated], rating: rating, tip_in_cents: tip)
    elsif Integer(update_params[:state_id]) == Order.states[:delivered]
      @order = Order.find_by(courier: current_user.couriers, id: update_params[:id])
      return render_not_found if @order.nil? || @order.delivered?

      @order.update_attributes!(state: Order.states[:delivered])

      # Send them a delivery notification on their first order.
      Sms::Notifications::DeliveryWorker.perform_async(@order.id) if @order.user.orders.count == 1
    end

    if @order.present?
      render action: :show
    else
      render_not_found
    end
  end

  private

    def place
      @place ||= Place.find_by(id: params[:place_id])
    end

    def order_params
      params.require(:food_id)
      params.require(:place_id)
      params.require(:price_id)
      params.permit(:food_id, :place_id, :price_id)
    end

    def update_params
      params.require(:id)
      params.permit(:state_id, :rating, :tip_in_cents, :id)
    end

    def shift
      @shift ||= Shift.find_by(courier: current_user.couriers, id: params[:shift_id])
    end

    def delivery
      @delivery ||= Delivery.for(food_id: order_params[:food_id], place_id: order_params[:place_id]).first
    end

    def apply_promo!
      apply_promo_to_user!(name: params[:promo_code])
    end

end
