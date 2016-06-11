class AddParentsEyesOnlyToPost < ActiveRecord::Migration
  def change
    add_column :posts, :parents_eyes_only, :boolean, default: false
  end
end
