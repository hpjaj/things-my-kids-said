class DropPostsUsersJoinTable < ActiveRecord::Migration
  def change
    drop_join_table(:posts, :users)
  end
end
