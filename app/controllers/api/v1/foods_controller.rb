class Api::V1::FoodsController < Api::V1::ApplicationController
  skip_before_action :require_current_user!

  def index
    @foods = Food.visible.limit(10)
  end

  def show
    @food = Food.find_by(id: params[:id])
  end

end
