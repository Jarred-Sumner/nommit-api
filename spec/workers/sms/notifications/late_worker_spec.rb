require 'rails_helper'

describe SMS::Notifications::LateWorker do

  let(:delivery_place) do
    dp = TestHelpers::Order.create_for.delivery_place
    allow(dp).to receive(:late?) { true }
    dp
  end

  subject do
    worker = SMS::Notifications::LateWorker.new
    worker.delivery_place = delivery_place
    worker
  end

  context "#perform" do

    it "sends a text" do
      allow(Texter).to receive(:run)
      expect(Texter).to receive(:run)

      subject.perform(delivery_place.id)
    end

    it "when the dp is on-time, it doesn't text" do
      allow(delivery_place).to receive(:late?) { false }
      expect(Texter).to_not receive(:run)
      subject.perform(delivery_place.id)
    end

  end

end