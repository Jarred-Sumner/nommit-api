require_relative "../../../rails_helper"

describe SMS::Notifications::FoodAvailableWorker do
  let(:food) { TestHelpers::Order.create_for.food }
  let(:user) { create(:user) }
  subject { SMS::Notifications::FoodAvailableWorker.new }

  before :each do
    food.update_attributes(notify: true)
    allow(Texter).to receive(:run)
  end

  context "#perform" do

    it "succeeds" do
      expect(Texter).to receive(:run)
      expect do
        subject.perform(user.id, food.id)
      end.to_not raise_error
    end

    it "doesnt send to food that isn't orderable" do
      allow_any_instance_of(Food).to receive(:orderable?) { false }
      expect(Texter).to_not receive(:run)

      subject.perform(user.id, food.id)

      expect(subject.message).to be_blank
    end

    it "doesnt send to users without a phone" do
      user.update_attributes(phone: nil)
      allow_any_instance_of(Food).to receive(:orderable?) { false }
      expect(Texter).to_not receive(:run)

      subject.perform(user.id, food.id)

      expect(subject.message).to be_blank
    end

    it "message contains credit" do
      user.applied_promos.create!(promo_id: create(:promo).id)
      subject.perform(user.id, food.id)
      expect(subject.message).to include((user.credit / 100.0).to_s)
    end

    it "message contains restaurant" do
      subject.perform(user.id, food.id)
      expect(subject.message).to include(food.restaurant.name)
    end

  end

end
