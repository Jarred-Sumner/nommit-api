class CouriersController < ApplicationController

  def me
    @courier = current_user.couriers.first
    render action: :show
  end

  def show
  end

end
