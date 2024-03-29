class Api::V1::SessionsController < Api::V1::ApplicationController
  skip_before_action :require_current_user!, :require_school!

  def create
    @user = User.authenticate_or_create!(session_params)
    response.headers["X-SESSION-ID"] = Session.find_by(access_token: session_params).token
    track_sign_in
  rescue Koala::Facebook::AuthenticationError, ActiveRecord::RecordInvalid => e
    Bugsnag.notify(e)
    render_error(status: :bad_request)
  end

  def destroy
  end

  private

    def session_params
      params.require(:access_token)
    end

end
