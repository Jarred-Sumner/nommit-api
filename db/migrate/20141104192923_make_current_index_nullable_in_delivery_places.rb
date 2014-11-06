class MakeCurrentIndexNullableInDeliveryPlaces < ActiveRecord::Migration
  def change
    change_column_null(:delivery_places, :current_index, true)
  end
end
