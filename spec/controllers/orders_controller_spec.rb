require_relative "../rails_helper"

describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:session) { create(:session) }

  before :each do
    request.headers["X-SESSION-ID"] = session.token
  end

  render_views

  describe "#create" do

    describe "with a missing food" do
      let(:place) { create(:place) }

      it "fails" do
        expect do
          post :create, place_id: place.id, quanttiy: 1
        end.to raise_error(ActionController::ParameterMissing)
      end

    end

    describe "to a place where that food isn't offered" do
      let(:courier) { create(:active_courier) }
      let(:shift) { create(:active_shift, courier_id: courier.id) }
      let(:delivery_place) { create(:delivery_place, shift_id: shift.id, place_id: create(:place).id) }
      let(:food) do
        food = create(:food, seller_id: courier.seller_id)
        Delivery.create!(food_id: food.id, delivery_place_id: delivery_place.id)
        food
      end
      let(:place) { create(:place) }

      it "fails" do
        expect do
          post :create, food_id: food.id, place_id: place.id, quantity: 1
        end.to_not change(Order, :count)

        expect(response.status).to eq(400)
      end

    end

    describe "with valid params" do
      let(:courier) { create(:active_courier) }
      let(:shift) { create(:active_shift, courier_id: courier.id) }
      let(:place) { create(:place) }
      let(:delivery_place) { create(:delivery_place, shift_id: shift.id, place_id: place.id) }
      let(:food) { create(:food, seller_id: courier.seller_id) }

      before :each do
        Delivery.create!(food: food, delivery_place: delivery_place)
      end

      it "succeeds" do
        expect do
          post :create, food_id: food.id, place_id: place.id, quantity: 1
        end.to change(Order, :count).by(1)

        expect(response.status).to eq(200)

        order_id = JSON.parse(response.body)['id']
        expect(Order.find(order_id)).to be_present
      end

    end

  end

end
