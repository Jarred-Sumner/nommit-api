class Api::V1::CouriersController < Api::V1::ApplicationController

  def me
    @couriers = current_user.couriers
  end

  def show
  end

end
