class Courier::ApplicationController < ApplicationController

  private

    def courier
      @current_courier ||= Courier.find_by(id: params[:id])
    end

    def seller
      @current_seller ||= courier.seller
    end

    def require_courier!
      render_forbidden unless current_courier.present?
    end

end
