require_relative "../../rails_helper"

describe PushNotifications::FoodUnavailableWorker do
  subject { PushNotifications::FoodUnavailableWorker.new }

  context "#perform" do

    it "ends the food" do
      food = create(:food, end_date: 1.week.ago)
      expect do
        subject.perform(food.id)
      end.to change { food.reload.state }.from("active").to("ended")
    end

    it "doesnt end the food" do
      food = create(:food, end_date: 1.week.ago)
      expect do
        subject.perform(food.id)
      end.to_not change { food.reload.state }
    end

  end

end
