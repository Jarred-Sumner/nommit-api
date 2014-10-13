require_relative "../rails_helper"

describe Order, type: :model do
  let(:courier) { create(:active_courier) }
  let(:shift) { create(:active_shift, courier_id: courier.id) }
  let(:place) { create(:place) }
  let(:delivery_place) { create(:delivery_place, shift_id: shift.id, place_id: place.id) }
  let(:food) { create(:food, seller_id: courier.seller_id) }
  let(:price) { food.prices.first }
  let(:user) { create(:user) }

  before :each do
    Delivery.create!(food: food, delivery_place: delivery_place)
  end

  context "promotions" do
    let(:discount) { 50 }
    let(:promo) { create(:promo, discount_in_cents: discount) }

    context "pending are applied to the next order" do
      before(:each) do
        user.user_promos.create!(promo_id: promo.id)
      end

      subject do
        user.orders.create! do |order|
          order.food_id = food.id
          order.price_id = price.id
          order.place_id = place.id
        end
      end

      it "successfully" do
        expect(subject.user_promos.count).to eq(1)
        expect(subject.discount_in_cents).to eq(discount)
        expect(subject.user_promos.first.reload.state).to eq('used_up')
      end

      it "with multiple" do
        second_promo = create(:promo, discount_in_cents: 25)
        user.user_promos.create!(promo_id: second_promo.id)

        expect(subject.user_promos.count).to eq(2)
        expect(subject.discount_in_cents).to eq(discount + second_promo.discount_in_cents)

        # All promos are used up
        expect(subject.user_promos.used_up.count).to eq(subject.user_promos.count)
      end

      it "with multiple where some have left over credit" do
        second_promo = create(:promo, discount_in_cents: price.price_in_cents + 100)
        u_promo = user.user_promos.create!(promo_id: second_promo.id)

        expect(subject.user_promos.count).to eq(2)
        expect(subject.discount_in_cents).to eq(subject.price_in_cents)

        # One promo is used up, the other isn't
        expect(subject.user_promos.used_up.count).to eq(1)
        expect(subject.user_promos.active.count).to eq(1)

        # The balance on this promo = original_balance - order_price - discount_on_first_promo
        balance = second_promo.discount_in_cents - subject.price_in_cents - discount
        expect(u_promo.reload.amount_remaining_in_cents).to eq(balance)
      end
    end

  end

end
