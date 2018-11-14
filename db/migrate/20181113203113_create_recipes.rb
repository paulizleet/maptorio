class CreateRecipes < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :ingredients
      t.string :products
      t.string :time
    end
  end
end
