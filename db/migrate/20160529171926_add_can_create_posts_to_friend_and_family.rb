class AddCanCreatePostsToFriendAndFamily < ActiveRecord::Migration
  def change
    add_column :friend_and_families, :can_create_posts, :boolean, default: false
  end
end
