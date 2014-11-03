require_relative "../rails_helper"

describe User, type: :model do

  context "#last_ordered" do

    let(:user) { create(:user) }

    it "is nil when no orders" do
      expect(user.last_ordered).to eq(nil)
    end

    context "shows the right date" do

      it "with one order" do
        TestHelpers::Order.create_for(user: user)
        expect(user.last_ordered).to eq(user.orders.first.created_at)
      end

      it "with multiple orders" do
        TestHelpers::Order.create_for(user: user)
        o = TestHelpers::Order.create_for(user: user)
        o.update_attributes(created_at: 1.year.from_now)
        expect(user.last_ordered).to eq(o.created_at)
      end
    end

  end

end
