class AddEtaToFoodDeliveryPlaces < ActiveRecord::Migration
  def change
    add_column :food_delivery_places, :eta, :datetime
  end
end
