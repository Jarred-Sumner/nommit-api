class PlacesController < ApplicationController

  def index
    @foods = Place.active.order('end_date ASC').limit(10)
  end

  def show
    @food = Place.find(params[:id])
  end

end
