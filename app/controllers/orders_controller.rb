class OrdersController < ApplicationController

  def index
    @orders = Order.where(user: current_user)
  end

  def show
    @order = Order.find_by(user: current_user, id: params[:id])
  end

  def create
    @location = Location.create(location_params)
    @order = Order.create!(order_params.merge(location: @location))
  rescue ActiveRecord::RecordInvalid => e
    render status: :bad_request, text: e.record.errors.full_messages
  end

  private

    def order_params
      params.allow(:food_id, :quantity)
    end

    def location_params
      params.allow(:address_one, :address_two, :instructions, :city, :state, :zip, :country)
    end

end
