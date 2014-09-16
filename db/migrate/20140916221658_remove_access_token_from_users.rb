class RemoveAccessTokenFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :access_token, :string
    remove_index :users, :access_token
  end
end
