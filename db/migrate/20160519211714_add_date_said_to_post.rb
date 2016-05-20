class AddDateSaidToPost < ActiveRecord::Migration
  def change
    add_column :posts, :date_said, :date
  end
end
