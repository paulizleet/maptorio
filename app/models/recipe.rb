require 'pry'

class Recipe
    include Mongoid::Document


    field :name, type: String
    field :energy
    field :category, type: String
    field :subgroup, type: String
    field :icon, type: String

    embedded_in :modsuite
    embeds_many :ingredients
    embeds_many :products
    

    def add_ingredients(item)
        print(item)
        if item["ingredients"]
            add_list(item["ingredients"])
        else
            add_list(item["normal"])
            add_list(item["expensive"])
        end
        self.save
    end
    


    def add_products(prd)
        prd.each do |pd|
           # @item = Item.where(name: pd[0])
            @product = self.products.new(name: pd[0], quantity: pd[1])
            @product.save
        end
        self.save
    end 


    def add_list(list)
        begin
            list.each do |ing|
                ing = [ing["name"], ing["amount"]] if ing.class == "Hash"
                #@item = Item.where(name: ing[0])
                @ingredient = self.ingredients.new(name: ing[0], quantity: ing[1])
                @ingredient.save
            end
        rescue
            binding.pry
        end
    end 


end
