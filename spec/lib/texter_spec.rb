require_relative "../rails_helper"

describe Texter do

  context "#perform" do
    let(:phone) { build(:user).phone }
    let(:message) { SecureRandom.urlsafe_base64 }
    let(:texter) { Texter.new(message, phone) }

    it "sends messages" do
      expect(texter.twilio.messages).to receive(:create)
      texter.perform
    end

  end

end
