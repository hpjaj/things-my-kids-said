class RemoveAttachmentPhotoOnUsers < ActiveRecord::Migration
  def self.up
    remove_attachment :users, :photo
  end

  def self.down
    change_table :users do |t|
      t.attachment :photo
    end
  end
end
