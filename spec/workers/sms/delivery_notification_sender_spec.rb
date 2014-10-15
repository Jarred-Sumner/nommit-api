require_relative "../../rails_helper"

describe Sms::DeliveryNotificationSender do
  let(:order) { TestHelpers::Order.create_for(params: { state: :delivered }) }

  subject { Sms::DeliveryNotificationSender.new }

  context "#perform" do
    it "sends text" do
      allow(Texter).to receive(:run)
      expect(Texter).to receive(:run).exactly(1).times
      subject.perform(order.id)
    end
  end

end
