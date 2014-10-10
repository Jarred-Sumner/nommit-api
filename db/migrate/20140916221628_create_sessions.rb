class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :user, index: true
      t.datetime :expiration
      t.text :access_token
      t.string :token, null: false

      t.timestamps
    end

    add_index :sessions, :access_token
    add_index :sessions, :token
  end
end
