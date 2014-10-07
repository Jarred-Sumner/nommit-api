class PlacesController < ApplicationController

  def index
    @places = Place.all.order("id DESC")
  end

  def show
    @place = Place.find(params[:id])
  end
end
