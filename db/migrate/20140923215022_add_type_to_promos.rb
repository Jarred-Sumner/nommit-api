class AddTypeToPromos < ActiveRecord::Migration
  def change
    add_column :promos, :type, :string
    add_index :promos, :type
  end
end
