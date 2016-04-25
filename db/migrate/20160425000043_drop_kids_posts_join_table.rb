class DropKidsPostsJoinTable < ActiveRecord::Migration
  def change
    drop_join_table(:kids, :posts)
  end
end
