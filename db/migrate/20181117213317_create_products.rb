class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.belongs_to :item
      t.belongs_to :recipe
      t.integer :quantity
    end
  end
end
