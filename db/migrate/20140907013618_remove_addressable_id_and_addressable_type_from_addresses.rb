class RemoveAddressableIdAndAddressableTypeFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :addressable_id
    remove_column :addresses, :addressable_type
  end
end
