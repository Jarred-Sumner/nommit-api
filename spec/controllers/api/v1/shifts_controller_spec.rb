require_relative "../../../rails_helper"

describe Api::V1::ShiftsController, type: :controller do
  let(:courier) { create(:courier) }
  let(:user) { courier.user }
  let(:shift) { create(:shift, courier_id: courier.id ) }

  before :each do
    session ||= create(:session, user_id: user.id)
    request.headers["X-SESSION-ID"] = session.token
  end
  render_views

  describe "#index" do

    context "with active shifts" do
      before :each do
        3.times do
          shift = create(:shift, courier_id: courier.id)
          dp = create(:delivery_place, shift_id: shift.id)
          Delivery.create!(food_id: create(:food, seller_id: courier.seller_id).id, delivery_place_id: dp.id)
        end
      end

      it "renders successfully" do
        get :index
        shifts = JSON.parse(response.body)
        expect(shifts.count).to be > 2
      end


    end

  end

  describe '#create' do

    let(:places) { 5.times.collect { create(:place).id } }
    it "creates a shift successfully" do
      expect do
        post :create, place_ids: places
      end.to change(Shift, :count).by(1)

      expect(response.status).to eq(200)
    end

    context "fails to create a shift without" do

      it "places" do
        post :create
        expect(response.status).to eq(400)
      end

      it "courier" do
        post :create, session_id: create(:session).token
        expect(response.status).to eq(400)
      end

    end

    context "fails to create a shift with an ongoing one" do
      before :each do
        create(:shift, courier_id: courier.id)
      end
    end

  end

  describe "#show" do
    it "should be successs" do
      get :show, id: shift.id
      expect(response.status).to eq(200)
    end
  end

  describe "#update" do
    let(:shift) { create(:active_shift, courier_id: courier.id) }

    context "with delivered orders" do

      before :each do
        5.times do
          place_id = shift.places.sample.id
          food_id = Delivery.joins(:delivery_place).where(delivery_places: { place_id: place_id }).first.food_id
          create(:order, place_id: place_id, state: Order.states[:delivered], food_id: food_id)
        end
      end

      it "ends the shift" do
        put :update, id: shift.id, state_id: Shift.states[:ended]
        expect(response.status).to eq(200)
        expect(shift.reload.state).to eq("ended")

        expect(shift.delivery_places.ended.count).to eq(shift.delivery_places.count)
      end

      context "and one active one" do
        before :each do
          place_id = shift.places.sample.id
          food_id = Delivery.joins(:delivery_place).where(delivery_places: { place_id: place_id }).first.food_id
          create(:order, place_id: place_id, food_id: food_id)
        end

        it "halts the shift and all the delivery places" do
          put :update, id: shift.id, state_id: Shift.states[:ended]
          expect(response.status).to eq(422)
          expect(shift.reload.state).to eq("halt")
          expect(shift.delivery_places.halted.count).to eq(shift.delivery_places.count)
        end

      end


    end

    context "lets you add more places to deliver to" do
      let(:new_places) { places = 5.times.collect { create(:place).id } }
      let(:place_ids) do
        shift.places.pluck(:id).concat(new_places)
      end

      specify do
        expect do
          put :update, id: shift.id, place_ids: place_ids
        end.to change { shift.places.count }.by(5)
        expect(response.status).to eq(200)
      end

    end

    context "doesn't let you remove places to deliver to" do
      specify do
        expect do
          put :update, id: shift.id, place_ids: [shift.places.pluck(:id).first]
        end.to_not change { shift.places.count }
        expect(response.status).to eq(400)
      end
    end

    context "lets you notify users of active delivery place" do
      let(:delivery_place) { shift.delivery_places.sample }
      let(:place) { delivery_place.place }

      specify do
        put :update, id: shift.id, delivery_place_state_id: DeliveryPlace.states[:arrived], delivery_place_id: delivery_place.id
        expect(response.status).to eq(200)
        expect(delivery_place.reload.state).to eq("arrived")
      end
    end

  end

end
