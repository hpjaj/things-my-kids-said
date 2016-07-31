class AddPictureReferenceOnPost < ActiveRecord::Migration
  def change
    add_reference :posts, :picture, index: true, foreign_key: false
  end
end
