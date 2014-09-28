class FoodDeliveryPlacesController < ApplicationController

  def index
    @food_delivery_places = FoodDeliveryPlace.deliverable
  end

end
