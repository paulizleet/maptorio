require "pry"
#require "language/lua"
require "json"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


#for each suite of mods
    @modsuite = Modsuite.new(name: "Vanilla", description: "Factorio recipes without any mods")
    #for each zipfile
        
        # run our lua scripts in shell

        `cd factorio && lua get_items.lua`

        `cd factorio && lua get_recipes.lua`

        f = open("items.json").read

        j = JSON.parse(f).to_h

        j.each_pair do |key, list_item|

            @item = @modsuite.items.new(
                name: list_item["name"],
                icon: list_item["icon"],
                subgroup: list_item["subgroup"]
            )
            @item.save
        end


        f = open("recipes.json").read
        j = JSON.parse(f).to_h
        j.each_pair do |key, list_item|


            @recipe = @modsuite.recipes.new(
                name: list_item["name"],
                icon: list_item["icon"],
                energy: list_item["energy_required"],
                category: list_item["category"],
                subgroup: list_item["subgroup"]
            )

            
            @recipe.add_ingredients(list_item)
            products = []
            if list_item["results"].nil?
                products = [[list_item["result"], list_item["result_count"].nil? ? 1 : list_item["result_count"]]]
            else
                products = list_item["results"]
            end
            @recipe.add_products(products)
            @recipe.save
        end
        @modsuite.save

puts Modsuite.first