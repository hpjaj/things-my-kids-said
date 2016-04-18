class CreateKidUserJoinTable < ActiveRecord::Migration
  def change
    create_table :kids_users, id: false do |t|
      t.belongs_to :kid, index: true
      t.belongs_to :user, index: true
    end
  end
end
