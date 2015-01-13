require 'rails_helper'

describe Notifications::LateWorker do
  
  let(:delivery_place) do
    dp = TestHelpers::Order.create_for.delivery_place
    allow(dp).to receive(:late?) { true }
    dp
  end

  subject do
    worker = Notifications::LateWorker.new
    worker.dp = delivery_place
    worker
  end

  context "#perform" do

    it "queues push when the courier has push-able devices" do
      create(:device, user_id: delivery_place.courier.user.id)
      expect do
        subject.perform(delivery_place.id)
      end.to change(PushNotifications::Courier::LateWorker.jobs, :size).by(1)
    end

    it "queues sms when the courier doesn't have push" do
      delivery_place.courier.user.devices.destroy_all
      expect do
        subject.perform(delivery_place.id)
      end.to change(SMS::Notifications::LateWorker.jobs, :size).by(1)
    end

    it "re-queues another worker when the worker is on-time" do
      allow(delivery_place).to receive(:late?) { false }
      allow(delivery_place).to receive(:active?) { true }
      expect do
        subject.perform(delivery_place.id)
      end.to change(Notifications::LateWorker.jobs, :size).by(1)
    end

  end

end