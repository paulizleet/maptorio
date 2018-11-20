class Recipe
    include Mongoid::Document

    field :name, type: String
    field :energy, type: Integer
    embeds_many :ingredients, class_name: "Item"
    embeds_many :products, class_name: "Item"
    



end
