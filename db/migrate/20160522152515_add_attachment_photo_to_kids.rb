class AddAttachmentPhotoToKids < ActiveRecord::Migration
  def self.up
    change_table :kids do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :kids, :photo
  end
end
