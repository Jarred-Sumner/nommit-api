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
    "+#{PhonyRails.normalize_number(raw_phone, default_country_code: "US")}"
  end

end
