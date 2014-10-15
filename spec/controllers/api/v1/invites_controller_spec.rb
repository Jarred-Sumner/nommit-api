require_relative "../../../rails_helper"

describe Api::V1::InvitesController do
  let(:user) { create(:user) }
  let(:session) { create(:session) }

  before :each do
    request.headers["X-SESSION-ID"] = session.token
  end

  context "#create" do
    let(:contacts) do
      contacts = []
      100.times do
        u = build(:user)
        contacts << {
          'phone' => u.phone,
          'name' => u.name
        }
      end
      contacts
    end

    specify do
      expect do
        post :create, contacts: contacts
      end.to change(InviteWorker.jobs, :size).from(0).to(2)
    end

  end

end
