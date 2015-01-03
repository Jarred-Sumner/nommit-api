class Api::V1::SellersController < Api::V1::ApplicationController

  # Send us an email to let us know there's a new seller
  def create
    SellersMailer.delay.apply_reminder(current_user.id)
    SellersMailer.delay.apply(current_user.id)
    render json: {}, status: 200
  end

end
