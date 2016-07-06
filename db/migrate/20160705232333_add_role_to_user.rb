class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, limit: 50
  end
end
