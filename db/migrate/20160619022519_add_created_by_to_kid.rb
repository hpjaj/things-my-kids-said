class AddCreatedByToKid < ActiveRecord::Migration
  def change
    add_column :kids, :created_by, :integer
  end
end
