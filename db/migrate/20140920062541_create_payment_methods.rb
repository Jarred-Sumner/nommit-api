class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.references :user, index: true
      t.string :customer

      t.timestamps
    end
    add_index :payment_methods, :customer
  end
end
