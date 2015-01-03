require 'rails_helper'

RSpec.describe Api::V1::SellersController, :type => :controller do
  let(:user) { create(:user) }
  let(:session) { create(:session, user_id: user.id ) }

  before :each do
    request.headers["X-SESSION-ID"] = session.token
    allow_any_instance_of(Texter).to receive(:perform)
  end

  describe "#create" do

    it "emails the applicant and us" do
      expect do
        post :create
      end.to change(Sidekiq::Extensions::DelayedMailer.jobs).by(2)
    end

  end

end
