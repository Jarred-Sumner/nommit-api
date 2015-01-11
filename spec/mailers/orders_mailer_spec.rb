require "rails_helper"

RSpec.describe OrdersMailer, :type => :mailer do
  
  describe "late" do
    let(:order) { TestHelpers::Order.create_for }
    let(:mail) { OrdersMailer.late(order.id) }
    let(:discount) { number_to_currency(order.late_discount_in_cents / 100.0) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mailers.order.late", discount: discount))
      expect(mail.to).to eq([order.user.email])
    end

    it "renders the body" do
      expect(mail.body).to be_present
    end
  end

  describe "cancelled" do
    let(:order) { TestHelpers::Order.create_for(params: { state: Order.states[:cancelled] }) }
    let(:mail) { OrdersMailer.cancelled(order.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mailers.order.cancelled", food: order.food.title))
      expect(mail.to).to eq([order.user.email])
    end

    it "renders the body" do
      expect(mail.body).to be_present
    end
  end

end
