class AddDeletedAtToKids < ActiveRecord::Migration
  def change
    add_column :kids, :deleted_at, :datetime
    add_index :kids, :deleted_at
  end
end
