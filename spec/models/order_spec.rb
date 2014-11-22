require_relative "../rails_helper"

describe Order, type: :model do
  let(:courier) { create(:active_courier) }
  let(:shift) { create(:active_shift, courier_id: courier.id) }
  let(:place) { create(:place) }
  let(:food_price) { 500 }
  let(:delivery_place) { create(:delivery_place, shift_id: shift.id, place_id: place.id) }
  let(:food) do
    food = create(:food, seller_id: courier.seller_id)
    food.set_prices!([food_price])
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

      context "successfully" do
        specify { expect(subject.applied_promos.count).to eq(1) }
        specify { expect(subject.discount_in_cents).to eq(discount) }
        specify { expect(subject.applied_promos.first.reload.state).to eq('used_up') }
      end

      context "with multiple" do
        let(:second_promo) { create(:promo, discount_in_cents: 25) }

        before :each do
          user.applied_promos.create!(promo_id: second_promo.id)
        end

        specify { expect(subject.applied_promos.count).to eq(2) }
        specify { expect(subject.discount_in_cents).to eq(discount + second_promo.discount_in_cents) }

        # All promos are used up
        specify { expect(subject.applied_promos.used_up.count).to eq(subject.applied_promos.count) }

        # None have negative credit
        specify { expect(subject.applied_promos.where("amount_remaining_in_cents < ?", 0).count).to eq(0) }
      end

      context "with multiple where some have left over credit" do
        let(:second_promo) { create(:promo, discount_in_cents: price.price_in_cents + 100) }
        let(:u_promo) { user.applied_promos.new(promo_id: second_promo.id) }

        before :each do
          u_promo.save!
        end

        specify { expect(subject.applied_promos.count).to eq(2) }
        specify { expect(subject.discount_in_cents).to eq(subject.price_in_cents) }

        # One promo is used up, the other isn't
        specify { expect(subject.applied_promos.used_up.count).to eq(1) }
        specify { expect(subject.applied_promos.active.count).to eq(1) }

        specify do
          balance = second_promo.discount_in_cents - (subject.price_in_cents - discount)
          expect(u_promo.reload.amount_remaining_in_cents).to eq(balance)
        end
      end

      context "with multiple that have no left over credit after ordering" do
        let(:other_promo) { create(:promo, discount_in_cents: food_price - discount) }
        let(:applied) { other_promo.applied_promos.new(user_id: user.id) }

        before :each do
          applied.save!
        end

        specify { expect(subject.applied_promos.used_up.count).to eq(subject.applied_promos.count) }
        specify { expect(subject.applied_promos.sum(:amount_remaining_in_cents)).to eq(0) }

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
          end.to change { referrer.applied_promos.active.count }.from(0).to(1)

          expect(
            referrer.applied_promos.active.sum(:amount_remaining_in_cents)
          ).to eq(referral_promo.discount_in_cents)
        end

        it "queues notification to referrer" do
          expect do
            subject
          end.to change(SMS::Notifications::ReferralCreditAppliedWorker.jobs, :size).from(0).to(1)
        end

      end

      it "applies only once to order" do
        expect do
          user.applied_promos.create!(promo_id: referral_promo.id)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

    end
  end

  context "doesn't let you place an order when" do

    context "food has" do

      subject { build(:order, food_id: food.id, place_id: place.id) }

      context "ended" do
        before :each do
          food.update_attributes(state: 'ended')
        end

        specify do
          expect do
            subject.save!
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "not started" do
        before :each do
          food.update_attributes(start_date: 1.day.from_now)
        end

        specify do
          expect do
            subject.save!
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "stopped being sold" do
        before :each do
          food.update_attributes(end_date: 1.day.ago)
        end

        specify do
          expect do
            subject.save!
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "run out" do
        before :each do
          food.update_attributes(goal: 0)
        end

        specify do
          expect do
            subject.save!
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

    end

    context "delivery place is" do

      context "halted" do
        before :each do
          delivery_place.update_attributes!(state: 'halted')
        end

        specify do
          expect do
            subject.save!
          end.to raise_error
        end
      end

      context "ended" do
        before :each do
          delivery_place.update_attributes!(state: 'ended')
        end

        specify do
          expect do
            subject.save!
          end.to raise_error
        end
      end

    end

  end

  context "after create" do
    subject { build(:order, place_id: place.id, food_id: food.id) }

    specify do
      expect do
        subject.save!
      end.to change { delivery_place.reload.state }.from("pending").to("ready")
    end

    it "queues a delivery notification to the courier" do
      expect do
        subject.save!
      end.to change(PushNotifications::Courier::DeliveryWorker.jobs, :size).from(0).to(1)
    end

    it "queues a hurry up notification to the courier" do
      expect do
        subject.save!
      end.to change(PushNotifications::Courier::HurryUpWorker.jobs, :size).from(0).to(1)
    end


  end
end
