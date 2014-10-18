class Api::V1::PlacesController < Api::V1::ApplicationController
  skip_before_action :require_current_user!, if: -> { params[:courier_id].blank? }
  def index
    if courier.present?
      these = Place
                .active
                .joins(:delivery_places => [:seller])
                .where({
                  sellers: {
                    id: courier.seller_id
                  }
                }).pluck("places.id")
      @places = Place.where.not(id: these).order("id DESC")
    else
      @places = Place.active.order("id DESC").uniq
    end
  end

  def show
    @place = Place.find(params[:id])
  end

  private

    def courier
      @courier ||= Courier.find_by(id: params[:courier_id]) if params[:courier_id].present?
    end
end
