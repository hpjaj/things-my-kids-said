class RemoveKidsAgeFromPost < ActiveRecord::Migration
  def change
    remove_column :posts, :kids_age
  end
end
