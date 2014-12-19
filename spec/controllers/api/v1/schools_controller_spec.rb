require_relative '../../../rails_helper'

describe Api::V1::SchoolsController, type: :controller do
  let(:user) { create(:user) }
  let(:session) { create(:session, user_id: user.id ) }
  render_views

  before :each do
    request.headers["X-SESSION-ID"] = session.token
    allow_any_instance_of(Texter).to receive(:perform)
  end

  context "#index" do

    specify do
      get :index
      expect(response.status).to eq(200) 
    end

    specify do
      school = create(:school)
      get :show, id: school.id
      expect(response.status).to eq(200)
    end

  end

end