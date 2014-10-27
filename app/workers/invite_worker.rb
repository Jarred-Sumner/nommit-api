class InviteWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, contacts = [])
    user = User.find(user_id)
    code = user.referral_promo.name
    last_name = user.name.split(" ").last if user.name.split(" ").count > 1
    contacts.each do |contact|
      message = "#{user.first_name}#{' ' + last_name[0] + '.' if last_name.present?} sent $5 credit to get food delivered to you in < 15 mins. Use code: #{code}. Get Nommit at http://www.getnommit.com/?i=#{code}. Only @ CMU."
      begin
        Texter.run(message, contact['phone'])
      rescue Twilio::REST::RequestError => e
        Bugsnag.notify(e)
      end
    end
  end
end
