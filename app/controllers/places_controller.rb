class PlacesController < ApplicationController

  def index
    @places = Place.all.includes(:location)
  end

  def show
    @place = Place.find(params[:id])
  end

end
