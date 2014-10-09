class CouriersController < ApplicationController

  def me
    @couriers = current_user.couriers
  end

  def show
  end

end
