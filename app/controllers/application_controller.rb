class ApplicationController < ActionController::Base


  def current_admin_user
    @current_session.try(:user).try(:admin?) ? @current_session.user : nil
  end

  def current_session
    @current_session ||= Session.includes(:user).find_by(token: sessions[:sessionID])
  end

end
