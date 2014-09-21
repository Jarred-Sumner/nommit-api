class RenameTransactionToCharge < ActiveRecord::Migration
  def change
    rename_table :transactions, :charges
  end
end
