class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :facebook_uid
      t.string :email
      t.string :phone
      t.string :name
      t.string :access_token
      t.datetime :last_signin

      t.timestamps
    end

    add_index :users, :facebook_uid
    add_index :users, :access_token
    add_index :users, :email

  end
end
