class Texter < Struct.new(:message, :to)
  PHONE = ENV["TWILIO_PHONE"] unless defined?(PHONE)

  def self.run(message, to)
    Texter.new(message, to).perform
  end

  def perform
    message << "\n - #{Rails.env.capitalize}" unless Rails.env.production?
    twilio.messages.create(
      from: PHONE,
      to: convert_to_e164(to),
      body: message
    )
  end

  def twilio
    @twilio ||= Twilio::REST::Client.new
  end

  def convert_to_e164(raw_phone)
    phone = Phony.normalize(String(raw_phone))
    phone = Phony.format(
      phone,
      format: :international,
      spaces: ''
    ).gsub(/\s+/, "") # Phony won't remove all spaces
    phone.insert(1, "1") if phone.length == 11 && phone[0] == "+"
    phone
  end

end