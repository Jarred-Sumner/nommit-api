class SessionsController < ApplicationController
  skip_before_action :require_current_user!

  def create
    @current_user = User.authenticate_or_create!(session_params)
    @foods = Food.active
  rescue Koala::Facebook::AuthenticationError, ActiveRecord::RecordInvalid
    render status: :bad_request, nothing: true
  end

  def destroy
  end

  private

    def session_params
      params.require(:access_token)
    end

end
