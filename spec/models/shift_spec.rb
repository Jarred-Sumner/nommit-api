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

    context "swaps the order of delivery places" do
      let(:dps) { shift.delivery_places.order("current_index ASC") }

      before :each do
        shift.update_delivery_times!(1)
      end

      specify do
        expect(dps.first.start_index).to eq(1)
        expect(dps.second.start_index).to eq(2)
        expect(dps.third.start_index).to eq(0)
      end

      it "except for the same delivery place" do
        shift.update_delivery_times!(0)
        expect(dps.first.start_index).to eq(1)
        expect(dps.second.start_index).to eq(2)
        expect(dps.third.start_index).to eq(0)
      end

    end

    it "updates delivery estimates" do
      order = shift.orders.first
      eta = order.delivered_at

      shift.update_delivery_times!(1)

      expect(order.reload.delivered_at > eta).to eq(true)
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
