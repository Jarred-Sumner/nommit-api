class FoodsController < ApplicationController

  def index
    @foods = Food.visible.limit(10)
  end

  def show
    @food = Food.find_by(id: params[:id])
  end

end
