class InviteWorker
  include Sidekiq::Worker

  def perform(user_id, contacts = [])
    user = User.find(user_id)
    code = user.referral_promo.name
    contacts.each do |contact|
      message = "#{user.first_name} gave you $5 credit to get food delivered to your building in under 15 minutes with Nommit. Your code is: #{code}"
      Texter.run(message, contact['phone'])
      Texter.run("Get the app at http://www.getnommit.com. Enter your code when you place the order. Only available at CMU.", contact['phone'])
    end
  end
end
