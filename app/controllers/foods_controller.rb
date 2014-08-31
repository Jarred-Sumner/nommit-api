class FoodsController < ApplicationController

  def index
    @foods = Food.all
    respond_with @foods
  end

  def show
  end

end
