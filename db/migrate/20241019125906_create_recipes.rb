class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.text :ingredients, null: false
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
