require 'pry'

class Recipe
    include Mongoid::Document

    field :name, type: String
    field :energy
    field :category, type: String
    field :subgroup, type: String
    field :icon, type: String
    has_many :ingredients
    has_many :products
    

    def add_ingredients(item)

        ingredients = []
        begin
            add_list(item["normal"])
            add_list(item["expensive"])
        rescue
            add_list(item["ingredients"])
        ensure
            self.save
        end
    end
    


    def add_products(prd)
        prd.each do |pd|
            @item = Item.where(name: pd[0])
            @product = self.products.new(item: @item, quantity: pd[1])
            @product.save
        end
        self.save
    end 


    def add_list(list)
            list.each do |ing|
                @item = Item.where(name: ing[0])
                @ingredient = self.ingredients.new(item: @item, quantity: ing[1])
                @ingredient.save
            end
    end 


end
