class AddFirstLastNamesToKid < ActiveRecord::Migration
  def change
    add_column :kids, :first_name, :string
    add_column :kids, :last_name, :string
    remove_column :kids, :name, :string
  end
end
