require_relative "../../../rails_helper"

describe PushNotiifcations::Courier::DeliveryWorker do
  subject { PushNotifications::Courier::DeliveryWorker.new }
  let(:order) { TestHelpers::Order.create_for }

  before :each do
    allow(subject.pusher).to receive(:push)
    create(:device, user_id: order.courier.user_id)
  end

  context "#perform" do

    it "sends push notifications" do
      expect(subject.pusher).to receive(:push)
      subject.perform(order.id)
    end

  end

end
