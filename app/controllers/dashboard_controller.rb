class DashboardController < ActionController::Base

  def index
  end

  def facebook
    @user = User.authenticate_or_create!(access_token)

    cookies[:sessionID] = Session.find_by(access_token: access_token).token
    session[:sessionID] = Session.find_by(access_token: access_token).token
    if session[:redirect_to_admin]
      session.delete(:redirect_to_admin)
      if @user.admin?
        redirect_to "/admin"
      else
        redirect_to "/"
      end
    else
      redirect_to omniauth_params['path']
    end
  rescue Koala::Facebook::AuthenticationError, ActiveRecord::RecordInvalid => e
    Bugsnag.notify(e)
    flash[:error] = "Could not log you in"
  end

  def logout
    cookies.delete(:sessionID)
    session.delete(:sessionID)
    redirect_to "/"
  end

  private

    def access_token
      request.env['omniauth.auth'][:credentials][:token]
    end

    def omniauth_params
      request.env["omniauth.params"]
    end


end
