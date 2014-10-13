class AddChargeToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :charge, :string
    add_index :charges, :charge
  end
end
