class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :order, index: true
      t.references :payment_method, index: true
      t.integer :state
      t.integer :amount_charged_in_cents

      t.timestamps
    end
    add_index :transactions, :state
  end
end
