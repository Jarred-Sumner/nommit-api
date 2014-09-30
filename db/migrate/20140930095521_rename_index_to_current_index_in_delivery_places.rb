class RenameIndexToCurrentIndexInDeliveryPlaces < ActiveRecord::Migration
  def change
    rename_column :delivery_places, :index, :current_index
  end
end
