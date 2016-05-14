class AddAgeToPost < ActiveRecord::Migration
  def change
    add_column :posts, :kids_age, :string
  end
end
