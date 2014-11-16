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
      subject.perform(food.id, User.first.id)
    end

  end

  context "#notification_params" do

    subject do
      worker = PushNotifications::FoodAvailableWorker.new
      worker.food = food
      worker.notification_params(device)
    end

    before :each do
      device.save!
    end

    it "set alert" do
      device.update_attributes!(last_notified: nil)

      expect(subject[:alert]).to be_present
      expect(subject[:alert].include?(food.title)).to eq(true)
    end

    it "sets device token" do
      expect(subject[:device_token]).to eq(device.device_token)
    end

    it "sets the expiration properly" do
      expect(subject[:expiry]).to eq(food.end_date.to_time)
    end

  end

end
