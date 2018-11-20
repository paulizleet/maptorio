class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|

      t.belongs_to :recipe
      t.belongs_to :products
      t.belongs_to :ingredients

      t.string :name
      t.string :type
      t.string :pretty_name
      t.string :icon
    end
  end
end
