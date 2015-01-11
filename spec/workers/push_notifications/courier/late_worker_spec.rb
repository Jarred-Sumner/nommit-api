require "rails_helper"

describe PushNotifications::Courier::LateWorker do

  context "#perform" do
    let(:order) { TestHelpers::Order.create_for }
    let(:delivery_place) { order.delivery_place }
    let(:food) { order.food }

    subject { PushNotifications::Courier::LateWorker.new }

    before :each do
      create(:device, user_id: delivery_place.courier.user_id)
      subject.delivery_place = delivery_place
    end

    specify do
      allow(delivery_place).to receive(:late?) { false }
      expect(subject.perform(delivery_place.id)).to eq(false)
    end

    specify do
      order.delivered!
      expect(subject.perform(delivery_place.id)).to eq(false)
    end

    specify do
      allow(delivery_place).to receive(:late?) { true }

      allow(subject.pusher).to receive(:push)
      expect(subject.pusher).to receive(:push)

      subject.perform(order.id)
    end

  end

end