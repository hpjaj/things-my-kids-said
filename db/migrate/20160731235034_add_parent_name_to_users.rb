class AddParentNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :parent_name, :string
  end
end
