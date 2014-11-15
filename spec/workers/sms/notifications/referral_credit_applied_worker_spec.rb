require_relative "../../../rails_helper"

describe SMS::Notifications::ReferralCreditAppliedWorker do
  let(:referrer) { create(:user) }
  let(:referred) { create(:user) }
  let(:applied_promo) { referred.applied_promos.create(promo_id: referrer.referral_promo.id) }

  before :each do
    allow(Texter).to receive(:run) { |message, phone| }
  end

  subject do
    SMS::Notifications::ReferralCreditAppliedWorker.new
  end

  it "runs successfully" do
    expect(Texter).to receive(:run)
    expect do
      subject.perform(applied_promo.id)
    end.to_not raise_error
  end

  it "sends to the referrer" do
    subject.referred = referred
    expect(Texter).to receive(:run).with(subject.message, referrer.phone)
    subject.perform(applied_promo.id)
  end

end
