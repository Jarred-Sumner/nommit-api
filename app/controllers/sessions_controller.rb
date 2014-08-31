class SessionsController < ApplicationController
  before_action :session_params

  def create
    if @user = User.authenticate_or_create!(session_params[:access_token])
      respond_with user
    else
      render status: :bad_request
    end
  end

  def destroy
  end

  private

    def session_params
      params.require(:access_token)
    end

end
