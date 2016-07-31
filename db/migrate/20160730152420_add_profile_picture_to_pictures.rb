class AddProfilePictureToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :profile_picture, :boolean, default: false
  end
end
