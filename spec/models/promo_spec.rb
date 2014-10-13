require 'rails_helper'

RSpec.describe Promo, type: :model do

  context "#usable_for?" do
    let(:promo) { create(:promo) }
    let(:user) { create(:user) }

    context "for promo that's already applied to account" do

      before :each do
        user.applied_promos.create(promo_id: promo.id)
      end

      it "returns false" do
        expect(promo.usable_for?(user: user)).to eq(false)
      end

    end

    context "for promo that's expired" do
      let(:promo) { create(:promo, expiration: 5.days.ago) }

      it "returns false" do
        expect(promo.usable_for?(user: user)).to eq(false)
      end
    end

    it "returns true" do
      expect(promo.usable_for?(user: user)).to eq(true)
    end

  end

end
