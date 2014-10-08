class AddSellerToDeliveryPlaces < ActiveRecord::Migration
  def change
    add_reference :delivery_places, :seller, index: true
  end
end
