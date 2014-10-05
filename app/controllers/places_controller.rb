class PlacesController < ApplicationController
  before_action :require_courier!

  def index
    @places = Place.all.order("id DESC")
  end

  def show
    @place = Place.find(params[:id])
  end
end
