require 'pry'

class Recipe
    include Mongoid::Document


    field :name, type: String
    field :expensive, type: Boolean
    field :energy
    field :energy_expensive
    field :category, type: String
    field :subgroup, type: String
    field :icon, type: String

    embedded_in :modsuite
    embeds_many :ingredients
    embeds_many :expensive_ingredients

    embeds_many :products

    validates :name, presence: true

    

    def add_ingredients(items)
        
        items.each do |i|
            @ingredient = self.ingredients.new(name: i[:name], quantity: i[:quantity])
            @ingredient.save
        end
        self.save
    end
    
    def add_expensive_ingredients(items)
        
        items.each do |i|
            @ingredient = self.expensive_ingredients.new(name: i[:name], quantity: i[:quantity])
            @ingredient.save
        end
        self.save
    end


    def add_products(prd)
        prd.each do |i|
            @product = self.products.new(name: i[:name], quantity: i[:quantity])
            @product.save
        end
        self.save

    end 



end
