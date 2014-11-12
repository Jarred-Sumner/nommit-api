require_relative "../../../rails_helper"

describe PushNotifications::Courier::HurryUpWorker do
  subject { PushNotifications::Courier::HurryUpWorker.new }
  let(:order) { TestHelpers::Order.create_for }

  before :each do
    allow(subject.pusher).to receive(:push)
    create(:device, user_id: order.courier.user_id)
  end

  context "#perform" do

    it "sends push notifications" do
      order.update_attributes!(delivered_at: 1.minute.from_now)
      expect(subject.pusher).to receive(:push)
      subject.perform(order.id)
    end

    context "won't send to orders that" do

      it "are delivered" do
        order.update_attributes!(state: Order.states[:delivered])
        expect(subject.pusher).to_not receive(:push)
        subject.perform(order.id)
      end

      it "aren't close to running late" do
        expect(subject.pusher).to_not receive(:push)
        subject.perform(order.id)
      end

    end

  end

end
