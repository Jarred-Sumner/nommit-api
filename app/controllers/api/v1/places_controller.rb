class Api::V1::PlacesController < Api::V1::ApplicationController
  skip_before_action :require_current_user!, if: -> { params[:courier_id].blank? }
  before_action :require_school!
  
  def index
    if courier.present?
      @places = school.places.order("name ASC")
    else
      @places = school.places.active.order("id DESC").uniq
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

    def courier
      @courier ||= Courier.find_by(id: params[:courier_id]) if params[:courier_id].present?
    end
end
