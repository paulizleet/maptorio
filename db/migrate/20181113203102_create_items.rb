class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|

      t.belongs_to :recipe
      t.string :name
      t.string :pretty_name
      t.string :icon

    end
  end
end
