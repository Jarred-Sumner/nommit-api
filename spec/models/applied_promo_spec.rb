require 'rails_helper'

RSpec.describe AppliedPromo, type: :model do
  let(:user) { create(:user) }
  context "#create" do
    let(:referral) { create(:user).referral_promo }
    let(:promo) { create(:promo) }

    it "doesn't work for applying new referral promos" do
      expect do
        user.applied_promos.create!(promo_id: referral.id)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
    
    it "works for applying promos" do
      expect do
        user.applied_promos.create!(promo_id: promo.id)
      end.to_not raise_error
    end

    it "requires promo_id" do
      expect do
        user.applied_promos.create!(promo_id: nil)
      end.to raise_error
    end

    it "works for applying multiple promos" do
      promos = [create(:promo), promo]

      expect do
        promos.each { |promo| user.applied_promos.create!(promo_id: promo.id) }
      end.to change(AppliedPromo, :count).from(0).to(2)
    end

  end
end
