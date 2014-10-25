require_relative '../../../rails_helper'

describe Api::V1::UsersController, type: :controller do
  render_views

  describe "#update" do
    let(:user) { create(:user) }
    let(:session) { create(:session, user_id: user.id ) }

    before :each do
      request.headers["X-SESSION-ID"] = session.token
      allow_any_instance_of(Texter).to receive(:perform)
    end

    context "given a valid token" do
      before { StripeMock.start }
      after { StripeMock.stop }

      let(:token) { "void_card_token" }

      it "creates a payment method" do
        expect do
          put :update, stripe_token: token, id: user.id
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
          put :update, stripe_token: token, id: user.id
        end.to_not change(PaymentMethod, :count)
        expect(response.status).to eq(400)
      end

    end

    context "registered user" do
      let(:user) { create(:registered_user, phone: nil) }
      let(:phone) { Faker::PhoneNumber.cell_phone }

      it "changes phone" do
        put :update, id: user.id, phone: phone
        expect(response.status).to eq(200)
        expect(user.reload.phone).to eq(PhonyRails.normalize_number(phone, default_country_code: "US"))
        expect(Sms::ConfirmCodeSender.jobs.size).to eq(1)
      end

      it "raises error on invalid phone phone" do
        put :update, id: user.id, phone: "bagels."
        expect(response.status).to eq(400)
        expect(user.reload.phone).to eq(nil)
        expect(Sms::ConfirmCodeSender.jobs.size).to eq(0)
      end

      it "sets User to activated on confirm" do
        expect do
          put :update, id: user.id, confirm_code: user.confirm_code
        end.to change { user.reload.state }.from("registered").to("activated")
      end

      it "resets confirm code on failed activation" do
        expect do
          put :update, id: user.id, confirm_code: "bagel"
        end.to change { Sms::ConfirmCodeSender.jobs.size }

        expect(user.reload.state).to eq("registered")
        expect(response.status).to eq(400)
      end

    end

  end

end
