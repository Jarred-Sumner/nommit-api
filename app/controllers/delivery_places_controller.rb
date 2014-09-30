class DeliveryPlacesController < ApplicationController
  before_action :require_courier!, :require_delivery_place!

  def update
    if Integer(delivery_place_params[:state_id]) == DeliveryPlace.states[:active]
      delivery_place.shift.delivery_places.update_all(state: "ready")
      delivery_place.arrived!
      delivery_place.shift.update_delivery_times!
    end
    render action: :show
  end

  def show
  end

  private

    def require_delivery_place!
      render_not_found unless delivery_place.present?
      render_forbidden if delivery_place.courier.id != courier.id
    end

    def delivery_place
      @deliver_place ||= DeliveryPlace.find_by(delivery_place_params[:id])
    end

    def delivery_place_params
      params.require(:id).permit(:state_id)
    end

end
