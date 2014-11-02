class Api::V1::DeliveryPlacesController < Api::V1::ApplicationController
  before_action :require_courier!, :require_delivery_place!, :require_authorized_courier!

  def update
    if Integer(delivery_place_params[:state_id]) == DeliveryPlace.states[:active]
      delivery_place.shift.delivery_places.update_all(state: DeliveryPlaces.states[:ready])
      delivery_place.arrived!
      delivery_place.shift.update_arrival_times!
    end
    render action: :show
  end

  def show

  end

  private

    def require_delivery_place!
      render_not_found unless delivery_place.present?
    end

    def require_authorized_courier!
      render_forbidden unless delivery_place.courier.id == courier.id
    end

    def delivery_place_params
      params.permit(:id, :state_id)
    end

end
