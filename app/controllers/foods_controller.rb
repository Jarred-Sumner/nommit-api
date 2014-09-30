class FoodsController < ApplicationController

  def index
    @foods = Food.visible
  end

  def show
    @food = Food.find_by(id: params[:id])
  end

end
