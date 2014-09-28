class Seller::OrdersController < Seller::ApplicationController
  before_action :require_courier!
  before_action :require_order!, only: :update

  def update

  end

  private

    def place
      @place ||= Place.find_by(id: params[:place_id])
    end

    def order
      @order ||= Order.find_by(place: params[:id])
    end

    def require_order!
      render_not_found if order.nil?
    end
end
