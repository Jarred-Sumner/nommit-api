require 'rails_helper'

describe Shift, type: :model do
  let(:courier) { create(:courier) }
  let(:seller) { courier.seller }
  let(:food) { create(:food, seller_id: seller.id) }
  let(:shift) do
    shift = create(:shift, courier_id: courier.id)
    dp_ids = []
    3.times { |i| dp_ids << create(:delivery_place, shift_id: shift.id).id }

    dp_ids.each { |id| Delivery.create(food_id: food.id, delivery_place_id: id) }
    shift
  end

  context "#update_arrival_times!" do
    let(:order) { build(:order, place_id: shift.delivery_places.pending.last.place_id, food_id: food.id, delivered_at: 1.minute.ago) }
    let(:dps) { shift.delivery_places.active }
    let(:place_order) { [] }

    before :each do
      shift.update_attributes(state: "active")
      place_ids = shift.delivery_places.pending.limit(2).pluck(:place_id)

      place_ids.each do |id|
        place_order.push id
        create(:order, place_id: id, food_id: food.id)
      end
    end

    it "appends new delivery places to the active list" do
      expect do
        order.save!
      end.to change(shift.delivery_places.active, :count).by(1)
    end

    it "reduces arrival times for existing delivery places" do
      orig_arrival_times = shift.delivery_places.active.pluck(:arrives_at)
      order.save!

      expect(orig_arrival_times.length > 0).to eq(true)
      expect(shift.delivery_places.active.count > 0).to eq(true)
      orig_arrival_times.each_with_index do |time, index|
        expect(dps[0].arrives_at < time).to eq(true)
      end
    end

    it "increases arrival times when delivery places are completed" do
      orig_arrival_times = shift.delivery_places.active.pluck(:arrives_at)

      shift.delivery_places.active.first.orders.first.delivered!

      expect(orig_arrival_times.length > 0).to eq(true)
      expect(shift.delivery_places.active.count > 0).to eq(true)
      shift.delivery_places.active.pluck(:arrives_at).each_with_index do |time, index|
        expect(time > orig_arrival_times[index]).to eq(true)
      end
    end

    it "is idempotent" do
      orig_arrival_times = shift.delivery_places.active.pluck(:arrives_at)
      shift.update_arrival_times!
      orig_arrival_times.each_with_index do |time, index|
        new_time = shift.delivery_places.active.pluck(:arrives_at)[index]
        expect(time).to eq(new_time)
      end
    end

    it 'orders delivery places properly' do
      order.save!
      place_order.push order.place_id

      # The correct order is where the first place has the "oldest" order and the last one has the "newest" order
      expect(shift.delivery_places.active.pluck(:place_id)).to eq(place_order)
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
