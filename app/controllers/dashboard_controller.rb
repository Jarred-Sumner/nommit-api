class DashboardController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def index
  end

  def login
    render template: 'dashboard/login', layout: false
  end

  def facebook
    @user = User.authenticate_or_create!(access_token)
    token = Session.find_by(access_token: access_token).token

    cookies[:sessionID] = { value: token, expiration: 10.minutes.from_now }
    session[:sessionID] = token
    if session[:redirect_to_admin]
      session.delete(:redirect_to_admin)
      if @user.admin?
        redirect_to "/admin"
      else
        redirect_to "/"
      end
    else
      redirect_to omniauth_params['path'] || root_url
    end
  rescue Koala::Facebook::AuthenticationError, ActiveRecord::RecordInvalid => e
    Bugsnag.notify(e)
    flash[:error] = "Could not log you in"
  end

  def logout
    current_session.try(:destroy)
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

    def current_session
      @current_session ||= Session.find_by(token: session[:sessionID])
    end

end
