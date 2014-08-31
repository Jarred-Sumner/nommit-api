class ApplicationController < ActionController::Base
  attr_writer :current_user
  respond_to :json

  def current_user
    @current_user ||= User.find_by(access_token: params[:access_token])
  end

  def require_current_user!
    render status: :unauthorized if current_user.nil?
  end

end
