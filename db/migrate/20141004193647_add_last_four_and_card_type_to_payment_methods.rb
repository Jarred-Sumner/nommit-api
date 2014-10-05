class AddLastFourAndCardTypeToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :last_four, :integer
    add_column :payment_methods, :card_type, :string
  end
end
