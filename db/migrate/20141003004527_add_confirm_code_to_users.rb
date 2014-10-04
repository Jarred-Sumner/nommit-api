class AddConfirmCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirm_code, :integer
  end
end
