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

def get_conditional_info(item, condition = false)
    info = {ingredients: [], products: [], energy: nil}
    if condition == false
        item["ingredients"].each do |r|
            begin
                #puts "funny ingredients in #{item["name"]}"

                info[:ingredients] << {name: r["name"], quantity: r["amount"]}
            rescue
                info[:ingredients] << {name: r[0], quantity: r[1]}
            end
        end

        info[:energy] = item["energy_required"]
        info[:energy] = 0.5 if info[:energy].nil?
        if !item["result"].nil?
            count = item["result_count"].nil? ? 1 : item["result_count"]
            info[:products] << {name: item["result"], quantity: count}
        else
            item["results"].each do |r|
                if r["name"].nil?
                    info[:products] << {name: r[0], quantity: r[1]}
                else
                    info[:products] << {name: r["name"], quantity: r["amount"]}
                end
            end
        end
    else
        return get_conditional_info(item[condition])
    end

    return info
end



#for each suite of mods
    @modsuite = Modsuite.new(name: "Vanilla", description: "Factorio recipes without any mods")
    #for each zipfile
        
        # run our lua scripts in shell

        `cd vendor/factorio && lua get_items.lua`

        `cd vendor/factorio && lua get_recipes.lua`

        f = open("vendor/factorio/items.json").read

        j = JSON.parse(f).to_h

        j.each_pair do |key, list_item|
           # binding.pry
            @item = @modsuite.items.new(
                name: list_item["name"],
                icon: list_item["icon"],
                subgroup: list_item["subgroup"]
            )
            if @item.valid?
                @item.save
            else
                binding.pry
            end
        end

        @modsuite.save

        f = open("vendor/factorio/recipes.json").read
        j = JSON.parse(f).to_h
        j.each_pair do |key, list_item|
            #binding.pry if "solid-fuel-from-light-oil" ==list_item["name"]
            puts list_item["name"]

            if list_item["normal"].nil?
                #binding.pry if list_item["name"] == "programmable-speaker"

                info = get_conditional_info(list_item)

                @recipe = @modsuite.recipes.new(
                    name: list_item["name"],
                    icon: list_item["icon"],
                    energy: info[:energy],
                    category: list_item["category"],
                    subgroup: list_item["subgroup"],
                    expensive: false
                )

                if !@recipe.valid?
                    p @recipe
                    exit
                end

                @recipe.add_ingredients(info[:ingredients])


                @recipe.add_products(info[:products])
                @recipe.save


            else

                #make recipes for normal difficulty
                info = get_conditional_info(list_item, "normal")

                @recipe = @modsuite.recipes.new(
                    name: list_item["name"] + "_normal",
                    icon: list_item["icon"],
                    energy: info[:energy],
                    category: list_item["category"],
                    subgroup: list_item["subgroup"],
                    expensive: false
                )

                @recipe.add_ingredients(info[:ingredients])
                @recipe.add_products(info[:products])
                @recipe.save


                info = get_conditional_info(list_item, "expensive")

                @recipe = @modsuite.recipes.new(
                    name: list_item["name"] + "_expensive",
                    icon: list_item["icon"],
                    energy: info[:energy],
                    category: list_item["category"],
                    subgroup: list_item["subgroup"],
                    expensive: true
                )

                #make recipes for expensive difficulty
                @recipe.add_ingredients(info[:ingredients])
                @recipe.add_products(info[:products])
                @recipe.save

            end

        end
        @modsuite.save
puts(Item.count)
BuildgraphsJob.perform_now
#puts Modsuite.first
puts(Item.count)
