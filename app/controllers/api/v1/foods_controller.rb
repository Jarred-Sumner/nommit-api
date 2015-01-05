class Api::V1::FoodsController < Api::V1::ApplicationController
  before_action :require_current_user!, :require_school!

  def index
    @foods = school.foods.visible.limit(10)
  end

  def show
    @food = school.foods.find_by(id: params[:id])
  end

end
