class Texter < Struct.new(:message, :to, :phone)

  def self.run(message, to, phone = ENV["TWILIO_PHONE"])
    Texter.new(message, to, phone).perform
  end

  def perform(phone = ENV["TWILIO_PHONE"])
    message << "\n - #{Rails.env.capitalize}" unless Rails.env.production?
    twilio.messages.create(
      from: phone,
      to: convert_to_e164(to),
      body: message
    )
  end

  def twilio
    @twilio ||= Twilio::REST::Client.new
  end

  def convert_to_e164(raw_phone)
    "+#{PhonyRails.normalize_number(raw_phone, default_country_code: "US")}"
  end

end
