require "rails_helper"

RSpec.describe FoodsMailer, :type => :mailer do
  describe "new" do
    let(:user) { create(:user) }
    let(:food) { create(:food) }
    let(:mail) { FoodsMailer.new(food.id, user.id) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["support@getnommit.com"])
    end

    it "renders the body" do
      expect(mail.body).to be_present
    end

  end

end
