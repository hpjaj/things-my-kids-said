class CreateFriendAndFamilies < ActiveRecord::Migration
  def change
    create_table :friend_and_families do |t|
      t.integer :kid_id
      t.integer :follower_id

      t.timestamps null: false
    end

    add_index :friend_and_families, :follower_id
    add_index :friend_and_families, :kid_id
    add_index :friend_and_families, [:follower_id, :kid_id], unique: true
  end
end
