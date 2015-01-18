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
    pending
  end

  context "#deliver!" do
    let(:order) { TestHelpers::Order.create_for }
    let(:shift) { order.shift }

    it "fails when you try to remove delivery places" do
      expect do
        shift.deliver! places: []
      end.to raise_error(ArgumentError)
    end

    it "fails when your shift is halted and you add more places" do
      shift.update_attributes!(state: Shift.states[:halt])
      new_place = create(:place, school_id: order.seller.school_id)
      expect do
        shift.deliver! places: shift.places.pluck("places.id") << new_place.id
      end.to raise_error(ArgumentError)
    end

    it "succeeds" do
      new_place = create(:place, school_id: order.seller.school_id)
      expect do
        shift.deliver! places: shift.places.pluck("places.id") << new_place.id
      end.to change(shift.reload.places, :count).by(1)
    end

    it "lets you add more places" do
      new_place = create(:place, school_id: order.seller.school_id)
      expect do
        shift.deliver! places: shift.places.pluck("places.id") << new_place.id
      end.to change { shift.delivery_places.reload.count }.by(1)
    end

    it "lets you add more foods" do
      new_food = create(:food, seller_id: order.seller.id)
      expect do
        shift.deliver! foods: shift.foods.pluck(:id) << new_food.id, places: shift.places.pluck(:id)
      end.to change { shift.foods.reload.count }.by(1)
    end

    it "lets you add sellable foods" do
      new_food = create(:sellable_food, seller_id: order.seller.id)
      new_version = create(:food, parent_id: new_food, seller_id: order.seller.id)
      expect do
        shift.deliver! foods: shift.foods.pluck(:id) << new_food.id, places: shift.places.pluck(:id)
      end.to change { shift.foods.reload.count }.by(1)
    end

  end

  context "#ended!" do
    pending
  end

  context "#halt!" do

    before :each do
      food = shift.foods.sample
      shift.delivery_places[0..1].each do |dp|
        TestHelpers::Order.create_for(params: { place_id: dp.place.id, food_id: food.id , price_id: food.prices.first.id })
      end
    end

    subject { shift.halt! }

    it "marks delivery places with orders as halted" do
      expect do
        subject
      end.to change { shift.delivery_places.halted.reload.count }.from(0).to(2)
    end

    it "marks delivery places without orders as ended" do
      expect do
        subject
      end.to change { shift.delivery_places.ended.reload.count }.from(0).to(shift.delivery_places.count - 2)
    end

  end

end
