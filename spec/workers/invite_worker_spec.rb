require_relative "../rails_helper"

describe InviteWorker do

  context "#perform" do
    subject { InviteWorker.new }
    let(:user) { create(:user) }

    it "sends texts to the right amount of people" do
      users = []
      25.times { users << build(:user) }
      allow(Texter).to receive(:run)
      expect(Texter).to receive(:run).exactly(2 * 25).times

      params = users.collect do |user|
        {
          'phone' => user.phone,
          'name' => user.name
        }
      end
      subject.perform(user.id, params)
    end
  end

end
