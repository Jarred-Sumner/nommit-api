class OrdersController < ApplicationController

  def index
    @orders = Order.where(user: current_user)
  end

  def show
    @order = Order.find_by(user: current_user, id: params[:id])
  end

  def create
    @address = Address.create(address_params)
    @order = Order.create!(order_params.merge(address: @address))
  rescue ActiveRecord::RecordInvalid => e
    render status: :bad_request, text: e.record.errors.full_messages
  end

  private

    def order_params
      params.allow(:food_id, :quantity)
    end

    def address_params
      params.allow(:address_one, :address_two, :instructions, :city, :state, :zip, :country)
    end

end
