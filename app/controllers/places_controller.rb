class PlacesController < ApplicationController

  def index
    @places = Place.active.order("id DESC")
  end

  def show
    @place = Place.find(params[:id])
  end
end
