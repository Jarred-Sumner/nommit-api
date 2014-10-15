require_relative "../../rails_helper"

describe Sms::ArrivalNotificationSender do

  context "#perform" do
    let(:courier) { create(:active_courier) }
    let(:shift) { create(:active_shift, courier_id: courier.id) }
    let(:food) { create(:food, seller_id: courier.seller_id) }
    let(:place) { create(:place) }
    let(:delivery_place) { create(:delivery_place, shift_id: shift.id, place_id: place.id, state: :arrived) }

    before :each do
      Delivery.create!(food: food, delivery_place: delivery_place)
      5.times { create(:order, place_id: place.id, user_id: create(:user).id, food_id: food.id, price_id: food.prices.first.id, state: :arrived) }
    end

    subject { Sms::ArrivalNotificationSender.new }

    it "sends 5 texts" do
      allow(Texter).to receive(:run)
      expect(Texter).to receive(:run).exactly(5).times
      subject.perform(shift.id)
    end

  end

end
