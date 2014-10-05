require_relative '../rails_helper'

describe UsersController, type: :controller do
  render_views

  describe "#update" do
    let(:registered_user) { User.create!(name: "Jarred Sumner", facebook_uid: "1664148201", email: "jarred@jarredsumner.com") }
    let(:session) { Session.create!(access_token: "blah", user_id: registered_user.id) }
    let(:phone) { Phony.normalize "+19252008843" }

    before :each do
      request.headers["X-SESSION-ID"] = session.token
    end

    it "changes phone" do
      put :update, id: registered_user.id, phone: phone
      expect(response.status).to eq(200)
      expect(registered_user.reload.phone).to eq(phone)
    end

    it "sets User to activated on confirm" do
      expect do
        put :update, id: registered_user.id, confirm_code: registered_user.confirm_code
      end.to change { registered_user.reload.state }.from("registered").to("activated")
    end

    it "resets confirm code on failed activation" do
      expect do
        put :update, id: registered_user.id, confirm_code: "bagel"
      end.to change { registered_user.reload.confirm_code }

      expect(registered_user.reload.state).to eq("registered")
      expect(response.status).to eq(400)
    end

    context "given a valid token" do
      before { StripeMock.start }
      after { StripeMock.stop }

      let(:token) { "void_card_token" }

      it "creates a payment method" do
        expect do
          put :update, stripe_token: token, id: registered_user.id
        end.to change(PaymentMethod, :count)
        expect(response.status).to eq(200)

        json = JSON.parse(response.body)
        expect(json['payment_authorized']).to eq(true)
      end

    end

    context "given invalid token" do
      let(:token) { "void_card_token" }

      it "doesn't create a payment method" do
        expect do
          put :update, stripe_token: token, id: registered_user.id
        end.to_not change(PaymentMethod, :count)
        expect(response.status).to eq(400)
      end

    end

  end

end
