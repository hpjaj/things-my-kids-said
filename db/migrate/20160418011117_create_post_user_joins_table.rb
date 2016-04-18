class CreatePostUserJoinsTable < ActiveRecord::Migration
  def change
    create_table :posts_users, id: false do |t|
      t.belongs_to :post, index: true
      t.belongs_to :user, index: true
    end
  end
end
