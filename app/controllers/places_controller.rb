class PlacesController < ApplicationController
  before_action :require_courier!

  def index
    @places = Place.all
  end
end
