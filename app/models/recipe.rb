require 'pry'

class Recipe
    include Mongoid::Document


    field :name, type: String
    field :expensive, type: Boolean
    field :energy
    field :category, type: String
    field :subgroup, type: String
    field :icon, type: String

    embedded_in :modsuite
    embeds_many :ingredients
    embeds_many :products

    validates :name, presence: true
    validates :energy, presence: true

    

    def add_ingredients(items)
        items.each do |i|
            @ingredient = self.ingredients.new(name: i[0], quantity: i[1])
            @ingredient.save
        end
    end
    


    def add_products(prd)
        prd.each do |i|
            self.save

            self.products.create(name: i[0], quantity: i[1])
        end
    end 



end
