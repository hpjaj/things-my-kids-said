class AddRelationshipNameToFriendAndFamilies < ActiveRecord::Migration
  def change
    add_column :friend_and_families, :relationship_name, :string
  end
end
