class InviteWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  INVITE_PHONE = ENV["TWILIO_INVITE_PHONE"] unless defined?(INVITE_PHONE)

  def perform(user_id, contacts = [])
    user = User.find(user_id)
    code = user.referral_promo.name
    last_name = user.name.split(" ").last if user.name.split(" ").count > 1
    contacts.collect do |contact|
      phone = contact['phone']

      normalized_phone = PhonyRails.normalize_number(phone, default_country_code: "US")
      next if User
        .where(phone: normalized_phone)
        .joins(:notification)
        .where("notifications.last_texted > ?", 1.week.ago)
        .count > 0

      begin
        u = User.create!(name: contact['name'], phone: normalized_phone, state: 'invited')
        u.notification = Notification.new
        u.notification.last_texted = DateTime.now
        u.notification.save!
      rescue Exception => e
        Bugsnag.notify(e)
      end

      first_name = contact['name']
      first_name = contact['name'].split(" ")[0] if first_name.present?

      if first_name.present?
        @message = "Yo #{first_name}! #{user.first_name}#{' ' + last_name[0] + '.' if last_name.present?} sent you $5 on Nommit. Get food delivered to you in 15 mins - only @ CMU. Use code: #{code}. http://www.getnommit.com/?i=#{code}"
      else
        @message = "#{user.first_name}#{' ' + last_name[0] + '.' if last_name.present?} sent you $5 on Nommit. Get food delivered to you in 15 mins - only @ CMU. Use code: #{code}. http://www.getnommit.com/?i=#{code}"
      end

      Texter.run(@message, contact['phone'], INVITE_PHONE)
    end
  end
end
