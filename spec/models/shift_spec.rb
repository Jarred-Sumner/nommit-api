require 'rails_helper'

describe Shift, type: :model do
  let(:courier) { create(:courier) }
  let(:seller) { courier.seller }
  let(:food) { create(:food, seller_id: seller.id) }
  let(:shift) do
    shift = create(:shift, courier_id: courier.id)
    dp_ids = []
    3.times { |i| dp_ids << create(:delivery_place, shift_id: shift.id, current_index: i).id }

    dp_ids.each { |id| Delivery.create(food_id: food.id, delivery_place_id: id) }
    shift
  end

  context "#update_delivery_times" do

    before :each do
      create(:order, place_id: shift.delivery_places.sample.place_id, food_id: food.id, delivered_at: 1.minute.ago)
    end

    it "swaps the order" do
      shift.update_delivery_times!(1)
      dps = shift.delivery_places.order("current_index ASC")

      expect(dps.first.start_index).to eq(1)
      expect(dps.second.start_index).to eq(2)
      expect(dps.third.start_index).to eq(0)
    end

    it "updates delivery estimates" do
      eta = shift.orders.first.delivered_at

      shift.update_delivery_times!(1)

      expect(shift.orders.first.delivered_at).to_not eq(eta)
    end
  end

  context "#eta_for" do

  end

  context "#deliver_to!" do

  end

  context "#ended!" do

  end

  context "#halt!" do

  end

end
