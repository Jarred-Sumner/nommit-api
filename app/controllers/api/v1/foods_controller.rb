class Api::V1::FoodsController < Api::V1::ApplicationController
  before_action :require_current_user!, :require_school!

  def index
    if seller.present?
      @foods = seller.sellable_foods
    else
      @foods = school.foods.visible.limit(10)
    end
  end

  def show
    @food = school.base_foods.find(params[:id])
  end

  private

    def seller
      @seller ||= Seller.find(params[:seller_id]) if params.has_key?(:seller_id)
    end

end
