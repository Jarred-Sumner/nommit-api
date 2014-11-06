class RemoveStartIndexFromDeliveryPlaces < ActiveRecord::Migration
  def change
    remove_column :delivery_places, :start_index, :integer
  end
end
