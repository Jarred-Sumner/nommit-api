require_relative '../../../rails_helper'

describe Api::V1::SessionsController, type: :controller do
  render_views

  context "#create" do
    before(:each) { Session.destroy_all && User.destroy_all }
    before(:each) { create(:user, :email => "jarred@jarredsumner.com", facebook_uid: "10203816999219792") }
    let(:access_token) { SecureRandom.urlsafe_base64 }

    it "works" do
      allow(User).to receive(:facebook_for) do |access_token|
        {
          'id' => '10203816999219792',
          'email' => 'jarred@jarredsumner.com',
          'name' => 'Jarred Sumner'
        }
      end
      expect do
        post :create, access_token: access_token
      end.to change(Session, :count).by(1)
      expect(response.headers["X-SESSION-ID"]).to eq(Session.first.token)
      expect(response.status).to eq(200)
    end

    it "doesnt work" do
      expect do
        post :create, access_token, access_token: "fail"
      end.to_not change(Session, :count)
      expect(response.headers["X-SESSION-ID"]).to be_blank
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to be_present
    end

  end

end
