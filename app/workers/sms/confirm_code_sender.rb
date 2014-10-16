require 'texter'

class Sms::ConfirmCodeSender
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    message = "Your confirm code for Nommit is: #{user.confirm_code}"
    Texter.run(message, user.phone)
  end
end