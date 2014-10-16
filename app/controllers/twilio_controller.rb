require 'twilio-ruby'

class TwilioController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def sms
    from = params[:From]
    TwilioAutomatedMessageWorker.perform_async(from)
    render nothing: true
  end

end
