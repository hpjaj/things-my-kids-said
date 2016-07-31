class RemoveAttachmentPhotoOnPosts < ActiveRecord::Migration
  def self.up
    remove_attachment :posts, :photo
  end

  def self.down
    change_table :posts do |t|
      t.attachment :photo
    end
  end
end
