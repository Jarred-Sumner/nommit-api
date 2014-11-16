class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.datetime :last_texted
      t.datetime :last_emailed
      t.references :user, index: true

      t.timestamps
    end
  end
end
