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

    context "handles poorly formatted numbers" do
      let(:phones) { ["(925) 596-8005", "(954) 260-4240"] }

      specify do
        phones.each do |phone|
          expect(texter.convert_to_e164(phone)).to eq("+1#{phone.gsub(/\(|\)| |\-/, "")}")
        end
      end

    end

  end

end
