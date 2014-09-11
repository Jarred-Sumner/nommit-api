class ApplicationController < ActionController::Base
  attr_writer :current_user

  before_action :set_format!, :require_current_user!

  def current_user
    @current_user ||= User.find_by(access_token: params[:access_token])
  end

  private

    def require_current_user!
      render status: :unauthorized if current_user.nil?
    end

    def set_format!
      request.format = :json
    end

end
