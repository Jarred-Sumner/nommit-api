class Api::V1::PlacesController < Api::V1::ApplicationController
  before_action :require_school!
  
  def index
    if index_params[:delivery] && current_user.couriers.count > 0
      @places = school.places.order("name ASC").uniq("places.id")
    else
      @places = school.places.active.order("id DESC").uniq("places.id")
      track_looked_at_places
      @for_orders_page = true
    end
  end

  def show
    @place = school.places.find(params[:id])
    track_checked_for_food(@place)
    @for_orders_page = true
  end

  private

    def index_params
      params.permit(:delivery)
    end

    def courier
      @courier ||= Courier.find_by(id: params[:courier_id]) if params[:courier_id].present?
    end
end
