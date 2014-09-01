class AddAttachmentPreviewToFoods < ActiveRecord::Migration
  def self.up
    change_table :foods do |t|
      t.attachment :preview
    end
  end

  def self.down
    remove_attachment :foods, :preview
  end
end
