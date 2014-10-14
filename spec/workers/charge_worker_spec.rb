require 'rails_helper'

describe ChargeWorker do
  let(:user) do
    user = create(:user)
    user.payment_method.destroy
    customer = Stripe::Customer.create({
      email: user.email,
      card: 'void_card_token'
    })

    create(:payment_method, customer: customer.id, user_id: user.id)
    user
  end

  let(:order) do
    TestHelpers::Order.create_for(user: user)
  end

  let(:charge) { order.charge }

  before { StripeMock.start }
  after { StripeMock.stop }

  context "#perform" do
    subject { ChargeWorker.new.perform(order.id) }
    let(:charge_amount) { order.price_in_cents + order.tip_in_cents - order.discount_in_cents }

    it "charges successfully" do
      expect { subject }.to change { charge.reload.state }.from("not_charged").to("paid")
    end

    it "charges appropriate amount" do
      subject
      expect(charge.amount_charged_in_cents).to eq(charge_amount)
    end

    context "with promotions" do
      let(:promo) { create(:promo) }

      before :each do
        user.applied_promos.create!(promo_id: promo.id)
      end

      it "charges appropriate amount" do
        subject
        expect(charge.amount_charged_in_cents).to eq(charge_amount)
      end

    end

    context "with tip" do
      let(:tip) { 100 }
      let(:order) { TestHelpers::Order.create_for(user: user, params: { tip_in_cents: tip }) }
      it "charges appropriate amount" do
        subject
        expect(charge.amount_charged_in_cents).to eq(charge_amount)
      end

    end

    context "with tip and promotion" do
      let(:tip) { 100 }
      let(:order) { TestHelpers::Order.create_for(user: user, params: { tip_in_cents: tip }) }
      it "charges appropriate amount" do
        subject
        expect(charge.amount_charged_in_cents).to eq(charge_amount)
      end

    end

    context "with invalid credit card" do
      before :each do
        StripeMock.prepare_card_error(:card_declined)
      end

      it "sets state to failed" do
        expect { subject }.to change { charge.reload.state }.from("not_charged").to("failed")
      end

    end

  end


end
