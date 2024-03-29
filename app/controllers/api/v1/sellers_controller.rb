class Api::V1::SellersController < Api::V1::ApplicationController
  after_action :track_seller_application, only: [:create]

  # Send us an email to let us know there's a new seller
  def create
    SellersMailer.delay.apply_reminder(current_user.id)

    # Delay slightly to make it seem like it wasn't automatic ;)
    SellersMailer.delay_for(rand(5.minutes..15.minutes)).apply(current_user.id)
    
    render json: {}, status: 200
  end

  def show
    @seller = current_user.sellers.find(show_params)
  end

  def index
    @sellers = current_user.sellers
  end

  def show_params
    params.require(:id)
  end

end
