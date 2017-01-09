class AddVisibleToToPost < ActiveRecord::Migration
  def change
    add_column :posts, :visible_to, :string
  end
end
