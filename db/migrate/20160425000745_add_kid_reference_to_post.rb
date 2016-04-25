class AddKidReferenceToPost < ActiveRecord::Migration
  def change
    add_reference(:posts, :kid, index: true)
  end
end
