class Recipe < ApplicationRecord

    has_many :ingredients, foreign_key: "item_id", class_name: "Item"
    has_many :products, foreign_key: "item_id", class_name, "Item"
    
end
