class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :ingredients
      t.string :preperation_type
      t.string :cook_time
      t.integer :user_id #author of recipe
      t.timestamps null: true
    end
  end
end
