require_relative "../rails_helper"

describe Order, type: :model do
  let(:courier) { create(:active_courier) }
  let(:shift) { create(:active_shift, courier_id: courier.id) }
  let(:place) { create(:place) }
  let(:delivery_place) { create(:delivery_place, shift_id: shift.id, place_id: place.id) }
  let(:food) do
    food = create(:food, seller_id: courier.seller_id)
    food.set_prices!([500])
    food
  end

  let(:price) { food.prices.first }
  let(:user) { create(:user) }

  before :each do
    Delivery.create!(food: food, delivery_place: delivery_place)
  end

  context "promotions" do

    subject do
      user.orders.create! do |order|
        order.food_id = food.id
        order.price_id = price.id
        order.place_id = place.id
      end
    end

    context "pending are applied to the next order" do
      let(:discount) { 50 }
      let(:promo) { create(:promo, discount_in_cents: discount) }

      before(:each) do
        user.applied_promos.create!(promo_id: promo.id)
      end

      it "successfully" do
        expect(subject.applied_promos.count).to eq(1)
        expect(subject.discount_in_cents).to eq(discount)
        expect(subject.applied_promos.first.reload.state).to eq('used_up')
      end

      it "with multiple" do
        second_promo = create(:promo, discount_in_cents: 25)
        user.applied_promos.create!(promo_id: second_promo.id)

        expect(subject.applied_promos.count).to eq(2)
        expect(subject.discount_in_cents).to eq(discount + second_promo.discount_in_cents)

        # All promos are used up
        expect(subject.applied_promos.used_up.count).to eq(subject.applied_promos.count)
      end

      it "with multiple where some have left over credit" do
        second_promo = create(:promo, discount_in_cents: price.price_in_cents + 100)
        u_promo = user.applied_promos.create!(promo_id: second_promo.id)

        expect(subject.applied_promos.count).to eq(2)
        expect(subject.discount_in_cents).to eq(subject.price_in_cents)

        # One promo is used up, the other isn't
        expect(subject.applied_promos.used_up.count).to eq(1)
        expect(subject.applied_promos.active.count).to eq(1)

        # The balance on this promo = original_balance - order_price - discount_on_first_promo
        balance = second_promo.discount_in_cents - subject.price_in_cents - discount
        expect(u_promo.reload.amount_remaining_in_cents).to eq(balance)
      end

    end

    context "from referral" do
      let(:referrer) { create(:user) }
      let(:referral_promo) { referrer.referral_promo }

      before :each do
        user.applied_promos.create!(promo_id: referral_promo.id)
      end

      context "applies to" do

        it "order" do
          expect(subject.applied_promos.count).to eq(1)
          expect(subject.discount_in_cents).to eq(referral_promo.discount_in_cents)
          expect(subject.applied_promos.first.reload.state).to eq('used_up')
        end

        it "referer" do
          expect do
            subject
          # from zero to one. :P
          end.to change { referrer.applied_promos.active.count }.from(0).to(1)

          expect(
            referrer.applied_promos.active.sum(:amount_remaining_in_cents)
          ).to eq(referral_promo.discount_in_cents)
        end

      end

      it "applies only once to order" do
        expect do
          user.applied_promos.create!(promo_id: referral_promo.id)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

    end
  end

end
