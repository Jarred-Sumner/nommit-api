require_relative '../rails_helper'

describe SessionsController, type: :controller do
  render_views

  context "#create" do
    before(:each) { Session.destroy_all }
    let(:access_token) { "CAAEof4vEg5QBAHxUNFboFI1wIA4BM4RlWSXC2k0kceNvBZA7y1ZBvyu3gyYoAZC5VooCFHITGnCIn7uVOXacSckXGW6rCzepJ9CLQr53USIasRPhN5ijSKVU8WygYOpJlOfAD6zmFRZBdwL012yKdcMtCr35781k5hNJzTBD0vrsIRtXBedz1D6rqQuBqReBg2n86F7xkUp4T2s61Rb3" }

    it "works" do
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
