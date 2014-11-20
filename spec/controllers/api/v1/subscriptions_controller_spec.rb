require_relative '../../../rails_helper'

describe Api::V1::SubscriptionsController, type: :controller do
  render_views

  describe "#create" do
    let(:user) { create(:user) }
    let(:session) { create(:session, user_id: user.id ) }

    before :each do
      request.headers["X-SESSION-ID"] = session.token
    end

    context "email" do

      specify do
        post :create, user_id: user.id, email: 0
        expect(user.reload.subscription.email).to eq(false)
      end

      specify do
        post :create, user_id: user.id, email: 1
        expect(user.reload.subscription.email).to eq(true)
      end

    end

    context "sms" do

      specify do
        post :create, user_id: user.id, sms: 0
        expect(user.reload.subscription.sms).to eq(false)
      end

      specify do
        post :create, user_id: user.id, sms: 1
        expect(user.reload.subscription.sms).to eq(true)
      end

    end


  end

end
