class CreateKidsPostsJoinsTable < ActiveRecord::Migration
  def change
    create_table :kids_posts, id: false do |t|
      t.belongs_to :kid, index: true
      t.belongs_to :post, index: true
    end
  end
end
