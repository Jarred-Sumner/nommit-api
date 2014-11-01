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

      subject { post :create, food_id: food.id, place_id: place.id, price_id: food.prices.first.id }

      it "succeeds" do
        expect(controller).to receive(:track_placed_order)
        expect do
          subject
        end.to change(Order, :count).by(1)

        expect(response.status).to eq(200)

        order_id = JSON.parse(response.body)['id']
        expect(Order.find(order_id)).to be_present

      end

      context "with failed payment method" do
        before :each do
          session.user.payment_method.failed!
        end

        it "fails" do
          expect do
            subject
          end.not_to change(Order, :count)

          expect(response.status).to eq(400)
        end
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
          expect(order.applied_promos.first.state).to eq("used_up")
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
          expect(order.applied_promos.first.state).to eq("active")
        end
      end

    end

  end

  describe "#update" do
    let(:courier) { create(:active_courier) }
    let(:shift) { create(:active_shift, courier_id: courier.id) }
    let(:place) { create(:place) }
    let(:delivery_place) { create(:delivery_place, shift_id: shift.id, place_id: place.id) }
    let(:food) { create(:food, seller_id: courier.seller_id) }
    let(:order) { create(:order, food_id: food.id, place_id: place.id, price_id: food.prices.first.id, user_id: user.id) }

    before :each do
      Delivery.create!(food: food, delivery_place: delivery_place)
    end

    describe "delivers" do

      subject do
        put :update, id: order.id, state_id: Order.states[:delivered]
      end

      context "from courier" do
        let(:session) { create(:session, user_id: courier.user_id) }

        specify do
          expect { subject }.to change { order.reload.state }.from("active").to("delivered")
        end

        specify do
          expect(controller).to receive(:track_delivered_order)
          subject
        end

        it "sends delivery notification on first order" do
          expect do
            subject
          end.to change(Sms::Notifications::DeliveryWorker.jobs, :size).from(0).to(1)
        end

        it "doesn't send delivery notification with past orders" do
          TestHelpers::Order.create_for(params: { user_id: order.user_id })
          expect do
            subject
          end.to_not change(Sms::Notifications::DeliveryWorker.jobs, :size)
        end

      end

      context "from random user" do
        let(:session) { create(:session) }

        it "doesn't work" do
          expect { subject }.to_not change { order.reload.state }
        end
      end

    end

    describe "rates" do
      let(:order) { create(:order, food_id: food.id, place_id: place.id, price_id: food.prices.first.id, user_id: user.id, state: Order.states[:delivered]) }

      before :each do
        request.headers["X-SESSION-ID"] = create(:session, user_id: order.user_id).token
      end

      context "from random user" do
        let(:session) { create(:session) }

        before :each do
          request.headers["X-SESSION-ID"] = session.token
        end

        it "doesn't work" do
          expect do
            put :update, id: order.id, state_id: Order.states[:rated]
          end.to_not change { order.reload.state }
        end

      end

      it "and tips" do
        tip = 1
        expect do
          put :update, id: order.id, state_id: Order.states[:rated], tip_in_cents: tip
        end.to change { order.reload.tip_in_cents }.from(0).to(tip)
      end

      it "doesn't let you tip an order that's already been charged" do
        order.charge.paid!
        expect do
          put :update, id: order.id, state_id: Order.states[:rated], tip_in_cents: 100
        end.to_not change { order.reload.tip_in_cents }
      end

      context "with a day old order" do
        before :each do
          order.update_attributes(created_at: 1.day.ago)
          order.charge.update_attributes(state: 'paid')
        end

        it "tipping fails" do
          put :update, id: order.id, state_id: Order.states[:rated], tip_in_cents: 500
          expect(order.reload.tip_in_cents).to eq(0)
          expect(response.status).to eq(400)
        end

        it "rating works" do
          put :update, id: order.id, state_id: Order.states[:rated], tip_in_cents: 0, rating: 2.0
          expect(response.status).to eq(200)
          expect(order.reload.rating).to eq(2.0)
        end
      end

      it "sets rating on food" do
        expect(controller).to receive(:track_rated_order)
        rating = 5.0
        put :update, id: order.id, state_id: Order.states[:rated], rating: rating
        expect(order.reload.rating).to eq(rating)
      end

    end

  end
end
