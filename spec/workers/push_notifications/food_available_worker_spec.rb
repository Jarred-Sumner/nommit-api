require_relative "../../rails_helper"

describe PushNotifications::FoodAvailableWorker do
  let(:food) do
    order = TestHelpers::Order.create_for
    order.food
  end
  let(:device) { build(:device) }
  subject { PushNotifications::FoodAvailableWorker.new }

  before :each do
    allow(subject).to receive(:pusher)
    allow(subject).to receive(:food) { food }
  end

  context "#perform" do

    before :each do
      device.save!
    end

    it "sends a push notification" do
      expect(subject.pusher).to receive(:push)
      subject.perform(food.id)
    end

  end

  context "#notification_params" do

    it "generates alert for devices that haven't been notified in awhile" do
      device.last_notified = nil
      device.save!

      params = subject.notification_params(device)
      expect(params[:alert]).to be_present
    end

    it "sets the expiration properly" do
      device.save!

      params = subject.notification_params(device)
      expect(params[:expiry]).to eq(food.end_date.to_time)
    end

  end

end
