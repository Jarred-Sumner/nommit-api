require 'rails_helper'

describe Api::V1::FoodsController, type: :controller do
  render_views

  let(:user) { create(:user, school_id: seller.school_id) }
  let(:session) { create(:session, user_id: user.id ) }
  let(:seller) { create(:seller) }

  before :each do
    request.headers["X-SESSION-ID"] = session.token

    3.times { create(:sellable_food, seller_id: seller.id) }
    f = create(:food, seller_id: seller.id)
  end

  context "#index" do

    it "only shows foods for the seller" do
      get :index, seller_id: seller.id

      body = JSON.parse(response.body)
      sellable_id = body.collect { |food| food['id'] }.sort
      food_ids    = seller.sellable_foods.pluck(:id).sort
      expect(sellable_id).to eq(food_ids)
    end

    it "only shows foods for the school" do
      get :index

      body = JSON.parse(response.body)
      ids = body.collect { |o| o['id'] }.sort
      expect(seller.school.foods.pluck(:id).sort).to eq(ids)
    end

  end

  context "#show" do

    it "loads food" do
      get :show, id: seller.foods.first.id
      expect(response.body).to be_present
    end

  end

end