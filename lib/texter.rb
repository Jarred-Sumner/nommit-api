class Texter < Struct.new(:message, :to)
  PHONE = ENV["TWILIO_PHONE"] unless defined?(PHONE)

  def perform
    message << "\n - #{Rails.env.capitalize}" unless Rails.env.production?
    message << "- NomBot"
    twilio.messages.create(
      from: PHONE,
      to: convert_to_e164(to),
      body: message
    )
  end

  private

    def convert_to_e164(raw_phone)
      phone = Phony.normalize(String(raw_phone))
      Phony.format(
        phone,
        format: :international,
        spaces: ''
      ).gsub(/\s+/, "") # Phony won't remove all spaces
    end

    def twilio
      @twilio ||= Twilio::REST::Client.new
    end
end
