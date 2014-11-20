require_relative "../../rails_helper"

describe Notifications::FoodAvailableWorker do
  let(:order) { TestHelpers::Order.create_for }
  let(:food) do
    order.food
  end

  before :each do
    allow(Texter).to receive(:run)
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

    it "reschedules food that isn't orderable yet" do
      food.update_attributes(start_date: 2.hours.from_now)
      subject.food = food
      expect do
        subject.perform(food.id)
      end.to change(Notifications::FoodAvailableWorker.jobs, :size)
    end

    it "creates a Notification for each user who doesn't have one" do
      food.save!
      expect do
        Notifications::FoodAvailableWorker.new.perform(food.id)
      end.to change(Subscription, :count).by(User.count)
    end

    it "texts everyone that hasn't recently ordered just once" do
      # - 1 for order.user
      expect(subject).to receive(:send_text!).exactly(User.count - 1).times
      subject.perform(food.id)
    end

    context "texts user" do
      let(:user) { create(:user) }

      it "successfully" do
        expect do
          subject.notify_user!(user)
        end.to change(SMS::Notifications::FoodAvailableWorker.jobs, :size).from(0).to(1)
      end

      it "when they ordered awhile ago" do
        order.update_attributes(created_at: 8.days.ago)
        expect do
          subject.notify_user!(user)
        end.to change(SMS::Notifications::FoodAvailableWorker.jobs, :size).from(0).to(1)
      end

      # it "unless they recently ordered" do
      #   expect do
      #     subject.notify_user!(order.user)
      #   end.to_not change(SMS::Notifications::FoodAvailableWorker.jobs, :size)
      # end

      # it "unless they ordered recently and awhile ago" do
      #   TestHelpers::Order.create_for(user: order.user, params: { created_at: 1.year.ago } )
      #   expect do
      #     subject.notify_user!(order.user)
      #   end.to_not change(SMS::Notifications::FoodAvailableWorker.jobs, :size)
      # end

      # it "unless we texted them recently" do
      #   user.subscription = Notification.create!(user_id: user.id, last_texted: 6.days.ago)
      #   expect do
      #     subject.notify_user!(user)
      #   end.to_not change(SMS::Notifications::FoodAvailableWorker.jobs, :size)
      # end

      it "unless they're unsubscribed" do
        user.subscription = Subscription.create!(user_id: user.id, sms: false)
        expect do
          subject.notify_user!(user)
        end.to_not change(SMS::Notifications::FoodAvailableWorker.jobs, :size)
      end

      it "when they haven't ordered recently" do
        TestHelpers::Order.create_for(user: user, params: { created_at: 1.year.ago })
        expect do
          subject.notify_user!(user)
        end.to change(SMS::Notifications::FoodAvailableWorker.jobs, :size).from(0).to(1)
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
        Subscription.create!(user_id: user.id, sms: false)
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
        user.subscription = Subscription.create!(sms: false, user_id: user.id)
        create(:device, user_id: user.id)
        user
      end

      it "successfully" do
        expect do
          subject.notify_user!(user)
        end.to change(PushNotifications::FoodAvailableWorker.jobs, :size).from(0).to(1)
      end

    end

  end

end
