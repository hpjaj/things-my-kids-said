class RemoveAttachmentPhotoOnKids < ActiveRecord::Migration
  def self.up
    remove_attachment :kids, :photo
  end

  def self.down
    change_table :kids do |t|
      t.attachment :photo
    end
  end
end
