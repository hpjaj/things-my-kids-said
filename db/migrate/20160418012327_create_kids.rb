class CreateKids < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.string :name
      t.date :birthdate
      t.string :gender

      t.timestamps null: false
    end
  end
end
