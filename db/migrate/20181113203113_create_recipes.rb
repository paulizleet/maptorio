class CreateRecipes < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :ingredients
      t.string :normal
      t.string :expensive
      t.string :products
      t.string :time_normal
      t.string :time_expensive
    end
  end
end
