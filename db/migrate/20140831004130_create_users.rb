class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :facebook_uid
      t.string :email
      t.string :phone
      t.string :access_token
      t.datetime :last_signin

      t.timestamps
    end
  end
end
