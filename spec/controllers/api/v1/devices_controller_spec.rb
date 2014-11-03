require 'rails_helper'

RSpec.describe Api::V1::DevicesController, :type => :controller do
  let(:user) { create(:user) }
  let(:session) { create(:session, user_id: user.id ) }

  before :each do
    request.headers["X-SESSION-ID"] = session.token
  end

  describe "POST create" do
    it "returns http success" do
      expect do
        post :create, token: "blah"
      end.to change(Device, :count).by(1)
      expect(response).to have_http_status(:success)
    end
  end

end
