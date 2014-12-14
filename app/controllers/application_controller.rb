class ApplicationController < ActionController::Base

  def authenticate_admin_user!
    if current_admin_user.nil?
      session[:redirect_to_admin] = true
      redirect_to "/auth/facebook"
    end
  end

  def current_admin_user
    current_session.try(:user).try(:admin?) ? @current_session.user : nil
  end

  def current_session
    @current_session ||= Session.includes(:user).find_by(token: session[:sessionID])
  end
end
