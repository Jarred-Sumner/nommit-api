class FoodsController < ApplicationController

  def index
    @foods = Food.active.order('end_date ASC').limit(10)
  end

  def show
    @food = Food.find(params[:id])
  end

end
