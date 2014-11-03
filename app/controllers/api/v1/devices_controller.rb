class Api::V1::DevicesController < Api::V1::ApplicationController

  def create
    Device.create! do |d|
      d.token = device_params[:token]
      d.platform = 'ios'
      d.user_id = current_user.id
      d.registered = true
    end
    track_registered_for_push

    render json: {}
  end

  private

    def device_params
      params.require(:token)
      params.permit(:token)
    end

end
