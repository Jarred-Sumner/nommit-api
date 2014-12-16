require "rails_helper"

RSpec.describe ReferralPromo, type: :model do
  let(:user) { create(:user) }
  let(:referral_promo) { user.referral_promo }

  context "#usable_for?" do

    context "false for" do

      it "applying to self" do
        expect(
          referral_promo.usable_for?(user: user)
        ).to eq(false)
      end

      it "user who already ordered and isn't the referer" do
        other = create(:user)
        TestHelpers::Order.create_for(user: other)

        expect(
          referral_promo.usable_for?(user: other)
        ).to eq(false)
      end

      # it "already applied a referral code" do
      #   other = create(:user)
      #   user.applied_promos.create!(promo_id: other.referral_promo.id)
      #
      #   second = create(:user)
      #   expect(second.referral_promo.usable_for?(user: user)).to eq(false)
      # end

    end

  end


end
