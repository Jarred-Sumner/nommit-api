require_relative "../../rails_helper"

describe Sms::ConfirmCodeSender do
  let(:user) { create(:registered_user) }

  subject { Sms::ConfirmCodeSender.new }

  context "#perform" do

    it "sends confirm code" do
      allow(Texter).to receive(:run) { |message, phone| [message, phone] }
      expect(Texter).to receive(:run).exactly(1).times
      text = subject.perform(user.id)
      expect(text[0]).to include(user.reload.confirm_code.to_s)
    end

  end
end
