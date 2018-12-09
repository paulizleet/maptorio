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

#make sure the factorio base repo is installed
`cd vendor/factorio && git clone https://github.com/wube/factorio-data.git`

#for each suite of mods
    @modsuite = Modsuite.new(name: "base", description: "Factorio recipes without any mods")
    #for each zipfile
        
        # run our lua script in shell

        `lua vendor/factorio/get_factorio.lua`

        f = open("vendor/factorio/items.json").read

        j = JSON.parse(f).to_h

        j.each_pair do |key, list_item|
           # binding.pry
           icon=nil
           begin
                icon = list_item["icon"].gsub(/(__base__)/, "")
           rescue
                icon = list_item["icons"]["icon"].gsub(/(__base__)/, "")
           end

            @item = @modsuite.items.new(
                name: list_item["name"],
                icon:   icon,
                subgroup: list_item["subgroup"]
            )
            if @item.valid?
                @item.save
            else
                binding.pry
            end
        end
        f = open("vendor/factorio/fluids.json").read

        icon=nil
        begin
             icon = list_item["icon"].gsub(/(__base__)/, "")
        rescue
            binding.pry

             icon = "vendor/happyface.jpg"
        end

        j = JSON.parse(f).to_h
        j.each_pair do |key, list_item|
            # binding.pry
             @item = @modsuite.items.new(
                 name: list_item["name"],
                 icon: icon,
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
            icon=nil
            begin
                 icon = list_item["icon"].gsub(/(__base__)/, "")
            rescue
                 icon = "vendor/happyface.jpg"
            end
 

            @recipe = @modsuite.recipes.new(
                name: list_item["name"],
                icon: icon,
                category: list_item["category"],
                subgroup: list_item["subgroup"],
                expensive: false
            )

            if !@recipe.valid?
                puts "invalid recipe"
                p @recipe
                exit
            end
            info = []

            if list_item["normal"].nil?
                info = get_conditional_info(list_item)

                @recipe.add_ingredients(info[:ingredients])
                @recipe.energy = info[:energy]
            
            else

                info = get_conditional_info(list_item, "normal")
                @recipe.add_ingredients(info[:ingredients])
                @recipe.energy = info[:energy]

                info = get_conditional_info(list_item, "expensive")
                @recipe.add_expensive_ingredients(info[:ingredients])
                @recipe.energy_expensive = info[:energy]

            end

            @recipe.add_products(info[:products])

            @recipe.save
        end
        @modsuite.save
BuildgraphsJob.perform_now
