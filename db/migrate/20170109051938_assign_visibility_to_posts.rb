class AssignVisibilityToPosts < ActiveRecord::Migration
  def up
    posts = Post.where(visible_to: nil)

    posts.update_all(visible_to: Visibility::FRIENDS)
  end

  def down
  end
end
