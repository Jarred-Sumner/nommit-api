class AddAttachmentLogoToSellers < ActiveRecord::Migration
  def self.up
    change_table :sellers do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :sellers, :logo
  end
end
