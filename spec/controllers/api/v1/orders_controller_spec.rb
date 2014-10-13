require_relative "../../../rails_helper"

describe Api::V1::OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:session) { create(:session) }

  before :each do
    request.headers["X-SESSION-ID"] = session.token
  end

  render_views

  describe "#create" do

    describe "with a missing food and price" do
      let(:place) { create(:place) }

      it "fails" do
        expect do
          post :create, place_id: place.id
        end.to raise_error(ActionController::ParameterMissing)
      end

    end

    describe "to a place where that food isn't offered" do
      let(:courier) { create(:active_courier) }
      let(:shift) { create(:active_shift, courier_id: courier.id) }
      let(:delivery_place) { shift.delivery_places.sample }
      let(:food) do
        food = create(:food, seller_id: courier.seller_id)
        Delivery.create!(food_id: food.id, delivery_place_id: delivery_place.id)
        food
      end
      let(:place) { create(:place) }

      it "fails" do
        expect do
          post :create, food_id: food.id, place_id: place.id, price_id: food.prices.first.id
        end.to_not change(Order, :count)

        expect(response.status).to eq(400)
      end

    end

    describe "to a place where the shift has ended" do
      let(:courier) { create(:active_courier) }
      let(:shift) { create(:ended_shift, courier_id: courier.id) }
      let(:place) { shift.places.sample }
      let(:delivery_place) { shift.delivery_places.sample }

      let(:food) { create(:food, seller_id: courier.seller_id) }

      before :each do
        delivery_place.update_attributes!(state: DeliveryPlace.states[:ended])
        Delivery.create!(food: food, delivery_place: delivery_place)
      end

      it "fails" do
        post :create, food_id: food.id, place_id: place.id, price_id: food.prices.first.id
        expect(response.status).to eq(400)
      end
    end

    describe "to a place where the food is halted" do
      let(:courier) { create(:active_courier) }
      let(:shift) { create(:active_shift, courier_id: courier.id, state: Shift.states[:halt]) }
      let(:delivery_place) { shift.delivery_places.sample }
      let(:food) { create(:food, seller_id: courier.seller_id) }

      before :each do
        delivery_place.update_attributes!(state: DeliveryPlace.states[:halted])
        Delivery.create!(food: food, delivery_place: delivery_place)
      end

      it "fails" do
        post :create, food_id: food.id, place_id: delivery_place.place_id, price_id: food.prices.first.id
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
          post :create, food_id: food.id, place_id: place.id, price_id: food.prices.first.id
        end.to change(Order, :count).by(1)

        expect(response.status).to eq(200)

        order_id = JSON.parse(response.body)['id']
        expect(Order.find(order_id)).to be_present
      end

      context "and a promo" do
        let(:promo) { create(:promo, discount_in_cents: 75) }

        it "succeeds" do
          expect do
            post :create, {
              'food_id' => food.id,
              'place_id' => place.id,
              'price_id' => food.prices.first.id,
              'promo_code' => promo.name
            }
          end.to change(Order, :count).by(1)

          order_id = JSON.parse(response.body)['id']
          order = Order.find_by(id: order_id)

          expect(response.status).to eq(200)

          expect(order).to be_present
          expect(order.discount_in_cents).to eq(promo.discount_in_cents)
          expect(order.user_promos.first.state).to eq("used_up")
        end

      end

      context "and a promo that results in a free order" do
        let(:promo) { create(:promo, discount_in_cents: food.prices.first.price_in_cents + 100) }

        it "succeeds" do
          expect do
            post :create, {
              'food_id' => food.id,
              'place_id' => place.id,
              'price_id' => food.prices.first.id,
              'promo_code' => promo.name
            }
          end.to change(Order, :count).by(1)

          order_id = JSON.parse(response.body)['id']
          order = Order.find_by(id: order_id)

          expect(response.status).to eq(200)

          expect(order).to be_present
          expect(order.discount_in_cents).to eq(order.price_in_cents)
          expect(order.user_promos.first.state).to eq("active")
        end
      end

    end

  end

end
