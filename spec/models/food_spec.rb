require_relative "../rails_helper"

describe Food, type: :model do

  context "on create it" do
    subject { build(:food) }

    specify do
      subject.notify = true
      expect do
        subject.save!
      end.to change(Notifications::FoodAvailableWorker.jobs, :size).by(1)
    end

    specify do
      expect do
        subject.save!
      end.to_not change(Notifications::FoodAvailableWorker.jobs, :size)
    end

  end

end
