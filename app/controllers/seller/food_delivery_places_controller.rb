class Seller::FoodDeliveryPlacesController < ApplicationController
  before_action :require_courier!, only: [:update, :update_in_batches, :index]
  before_action :require_food_delivery_place!, except: :index

  def index
    @food_delivery_places = FoodDeliveryPlace.where(seller: courier.seller).deliverable
  end

  def update_in_batches

  end

  def show
  end

  def update
  end

  private

    def seller
      @seller ||= courier.seller
    end

end
