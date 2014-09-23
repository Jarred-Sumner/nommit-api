class PlacesController < ApplicationController

  def index
    @places = Place.active.order('end_date ASC').limit(10)
  end

  def show
    @place = Place.find(params[:id])
  end

end
