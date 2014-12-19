require_relative "../../rails_helper"

describe Notifications::FoodAvailableWorker do
  let(:order) { TestHelpers::Order.create_for }
  let(:food) do
    order.food.update_attributes(notify: true)
    order.food
  end

  before :each do
    allow(Texter).to receive(:run)
    User.update_all(school_id: food.seller.school_id)
  end

  context "#perform" do
    subject do
      worker = Notifications::FoodAvailableWorker.new
      worker.food = food
      worker
    end

    before :each do
      create(:user)
      create(:registered_user)
    end

    it "skips food that isn't orderable yet" do
      food.update_attributes(start_date: 2.hours.from_now)
      subject.food = food
      expect(subject).to_not receive(:notify_user!)
      subject.perform(food.id)
    end

    it "skips food that's already been notified" do
      food.update_attributes(last_notified: 2.minutes.ago)
      subject.food = food
      expect(subject).to_not receive(:notify_user!)
      subject.perform(food.id)
    end

    it "reschedules food that isn't orderable yet" do
      food.update_attributes(start_date: 2.hours.from_now)
      subject.food = food
      expect do
        subject.perform(food.id)
      end.to change(Notifications::FoodAvailableWorker.jobs, :size)
    end

    it "texts everyone that just once" do
      expect(subject).to receive(:send_text!).exactly(food.school.users.count - 1).times
      subject.perform(food.id)
    end

    context "texts user" do
      let(:user) { create(:user) }
    
      it "successfully" do
        expect do
          subject.notify_user!(user)
        end.to change(SMS::Notifications::FoodAvailableWorker.jobs, :size).from(0).to(1)
      end

      it "unless they're unsubscribed" do
        user.subscription.update_attributes(sms: false)
        expect do
          subject.notify_user!(user)
        end.to_not change(SMS::Notifications::FoodAvailableWorker.jobs, :size)
      end

    end

    context "emails user" do
      let(:user) { create(:user) }

      subject do
        worker = Notifications::FoodAvailableWorker.new
        worker.food = food
        worker.notify_user!(user)
      end

      before :each do
        user.subscription.update_attributes(sms: false)
      end

      it "successfully" do
        expect do
          subject
        end.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).from(0).to(1)
      end

      it "unless they've unsubscribed" do
        user.subscription.update_attributes!(email: false)
        expect do
          subject
        end.to_not change(Sidekiq::Extensions::DelayedMailer.jobs, :size)

      end

    end

    context "sends push notification" do
      let(:user) do
        user = create(:user)
        user.subscription.update_attributes(sms: false)
        create(:device, user_id: user.id)
        user
      end

      it "successfully" do
        expect do
          subject.notify_user!(user)
        end.to change(PushNotifications::FoodAvailableWorker.jobs, :size).from(0).to(1)
      end

    end

    it "marks food as notified" do
      expect do
        subject.perform(food.id)
      end.to change { food.reload.last_notified.present? }.from(false).to(true)
    end

  end

end
