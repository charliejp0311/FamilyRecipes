class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment
      t.integer :recipe_id
      t.integer :user_id #author of comment
      t.timestamps null: true
    end
  end
end
