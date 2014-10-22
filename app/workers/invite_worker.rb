class InviteWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, contacts = [])
    user = User.find(user_id)
    code = user.referral_promo.name
    contacts.each do |contact|
      message = "#{user.first_name} sent $5 credit to get food delivered to you in < 15 mins. Use code: #{code}. Get Nommit at http://appstore.com/nommit. Only at CMU."
      begin
        Texter.run(message, contact['phone'])
      rescue Twilio::REST::RequestError => e
        Bugsnag.notify(e)
      end
    end
  end
end
