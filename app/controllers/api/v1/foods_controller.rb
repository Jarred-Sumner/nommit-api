class Api::V1::FoodsController < Api::V1::ApplicationController
  before_action :require_courier!, only: [:create, :update]

  def index
    if seller.present?
      @foods = seller.sellable_foods
    else
      @foods = school.foods.visible.limit(10)
    end
  end

  def create
    @food = seller.sellable_foods.create!(modify_params)
    render partial: "api/v1/foods/food", food: @food
  end

  def update
    @food = seller.sellable_foods.find(Integer(params[:id]))
    @food.update_attributes!(modify_params)
    render action: :show
  end

  def show
    @food = school.base_foods.find(params[:id])
  end

  private

    def seller
      @seller ||= courier.try(:seller)
    end

    def modify_params
      params.require(:seller_id)
      params.require(:title)
      params.require(:description)
      params.require(:goal)
      params.require(:preview)

      params.permit([:seller_id, :title, :description, :goal, :preview])      
    end

end
