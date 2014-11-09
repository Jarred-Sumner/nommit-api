class Api::V1::OrdersController < Api::V1::ApplicationController
  before_action :apply_promo!, only: :create, if: -> { params[:promo_code].present? }

  def index
    if place.present?
      @orders = place
        .orders
        .where(courier: current_user.couriers.first)
        .joins(:user)
        .order("users.name")
    elsif shift.present?
      @orders = shift.orders
    else
      @orders = Order.where(user: current_user).order("created_at DESC").limit(10)
      @orders = @orders.where(state: Integer(index_params[:state_id])) if index_params[:state_id].present?
    end
  end

  def show
    @order = Order.find_by(user: current_user, id: params[:id])
  end

  def create
    @order = Order.create!(order_params.merge(user_id: current_user.id))
    track_placed_order(@order)
    if @order.food.remaining.zero?
      @order.food.ended!
      track_food_sold_out(@order.food)
    end
    render action: :show
  rescue ActiveRecord::RecordInvalid => e
    render_error(status: :bad_request, text: e.record.errors.full_messages.first)
  end

  def update
    if Integer(update_params[:state_id]) == Order.states[:rated]
      @order = Order.find_by(user_id: current_user.id, id: update_params[:id])
      return render_bad_request("Cannot make changes to this order") if @order.nil? || @order.rated? || !@order.delivered?

      begin
        if @order.charge.paid? && update_params[:tip_in_cents].present? && Integer(update_params[:tip_in_cents]) > 0
          return render_bad_request("Cannot tip an order 24 hours later -- your card has already been charged.")
        end
      rescue ArgumentError
      end

      rating = Float(update_params[:rating] || 4)
      tip    = Integer(update_params[:tip_in_cents] || 0)
      @order.update_attributes!(state: Order.states[:rated], rating: rating, tip_in_cents: tip)
      track_rated_order(@order)
    elsif Integer(update_params[:state_id]) == Order.states[:delivered]
      @order = Order.find_by(courier: current_user.couriers, id: update_params[:id])
      return render_not_found if @order.nil? || @order.delivered?

      @order.delivered!

      # Send them a delivery notification on their first order.
      Sms::Notifications::DeliveryWorker.perform_at(20.minutes.from_now, @order.id) if @order.user.orders.count == 1
      track_delivered_order(@order)

      # End the shift automatically when the shift is halted and there are no more pending orders
      if @order.shift.halt? && @order.shift.orders.pending.count.zero?
        @order.shift.ended!
      end

    elsif Integer(update_params[:state_id]) == Order.states[:cancelled]
      @order = current_user.orders.find(update_params[:id])
      return render_bad_request("Can only cancel within two minutes of placing the order.") if @order.created_at < 2.minutes.ago
      return render_bad_request("Can't cancel an order that's been delivered") if @order.delivered? || @order.rated?

      @order.cancelled!
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

    def index_params
      params.permit(:state_id)
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
