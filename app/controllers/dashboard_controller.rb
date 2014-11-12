class DashboardController < ActionController::Base

  def index
  end

  def facebook
    @user = User.authenticate_or_create!(access_token)

    cookies[:sessionID] = Session.find_by(access_token: access_token).token
    redirect_to new_order_path(omniauth_params)
  rescue Koala::Facebook::AuthenticationError, ActiveRecord::RecordInvalid => e
    Bugsnag.notify(e)
    flash[:error] = "Could not log you in"
  end

  private

    def access_token
      request.env['omniauth.auth'][:credentials][:token]
    end

    def omniauth_params
      request.env["omniauth.params"]
    end


end
