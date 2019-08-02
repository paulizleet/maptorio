require "pry"
#require "language/lua"
require "json"
require 'zip'
require_relative "lua_stuff"
#require 'FileUtils'
Zip.on_exists_proc = true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#We only want new errors!
`rm errors`

def get_conditional_info(item, locale_item, condition = false)
    info = {ingredients: [], products: [], energy: nil}
    if condition == false
        item["ingredients"].each do |r|
            begin
                #puts "funny ingredients in #{item["name"]}"
                info[:ingredients] << {local_name: locale_item[r["name"]],name: r["name"], quantity: r["amount"]}
            rescue
                info[:ingredients] << {local_name: locale_item[r[0]],name: r[0], quantity: r[1]}
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
                    info[:products] << {local_name: locale_item[r["name"]],name: r[0], quantity: r[1]}
                else
                    info[:products] << {local_name: locale_item[r[0]],name: r["name"], quantity: r["amount"]}
                end
            end
        end
    else
        return get_conditional_info(item[condition], locale_item)
    end

    return info
end



def move_graphics(pack)
    #puts Dir.pwd
    return
    begin
        Dir.mkdir("public/graphics/")
    rescue
        nil
    end

    begin
        Dir.mkdir("public/graphics/#{pack}")
    rescue
        nil
    end
    if pack == "base"
        FileUtils.copy_entry("vendor/factorio/factorio-data/base/graphics/","public/graphics/base/graphics")
        return
    end

    zips = Dir.entries("vendor/factorio/factorio-data/mod/#{pack}")

    zips.each do |z|
        next if z == '.' || z == ".." 
        #puts z

        begin
            Dir.mkdir("public/graphics/#{pack}/#{z}")
            Dir.mkdir("public/graphics/#{pack}/#{z}/graphics")

        rescue
            nil
        end

        FileUtils.copy_entry("vendor/factorio/factorio-data/mod/#{pack}/#{z}/graphics/","public/graphics/#{pack}/#{z}/graphics")
    end

end

def build_modpack(pack, desc = "factorio mods :D")

    item_names = {}
    recipe_names = {}
    if pack == "base"
        english = open("vendor/factorio/factorio-data/base/locale/en/base.cfg").read
        item_time = false
        recipe_time = false
        sps = english.split("\n")
        
        i=-1
        while i < sps.length
            i+=1
            e = sps[i]
            item_time = true if e == "[item-name]" || e == "[fluid-name]" || e == "[entity-name]"
            recipe_time = true if e == "[recipe-name]"
            if e == ""
                item_time = false
                recipe_time = false
            end
            next if !item_time && !recipe_time

            if item_time
                s = e.split("=")
                item_names.merge!({s[0]=> s[1]})
            end
            if recipe_time
                s = e.split("=")
                recipe_names.merge!({s[0]=> s[1]})
            end
        end

    end




    f = open("vendor/factorio/items.json").read

    j = JSON.parse(f).to_h
    
    @modsuite = Modsuite.new(name: pack, description: desc)

    j.each_pair do |key, list_item|
        # binding.pry
        icon=nil
        begin
            icon = "/graphics/#{pack}/" + list_item["icon"].gsub(/(__base__)/, "")
        rescue
            icon = "/graphics/#{pack}/" + list_item["icons"][0]["icon"]
        end

        @item = @modsuite.items.new(
            name: list_item["name"],
            local_name:  pack == "base" ? item_names[list_item["name"]] : "fancy_" + list_item["name"],
            icon:   icon,
            subgroup: list_item["subgroup"]
        )

        #binding.pry

        if @item.valid?
            @item.save
        else
            binding.pry
        end
    end
    f = open("vendor/factorio/fluids.json").read

    icon=nil
    begin
         icon = "/#{pack}"+list_item["icon"].gsub(/(__base__)/, "")
    rescue
         icon = "/graphics/happyface.jpg"
    end

    j = JSON.parse(f).to_h
    j.each_pair do |key, list_item|
        # binding.pry
            @item = @modsuite.items.new(
                name: list_item["name"],
                local_name: pack == "base" ? item_names[list_item["name"]] : "fancy_" + list_item["name"],
                icon: icon,
                subgroup: list_item["subgroup"],

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
            local_name: pack == "base" ? recipe_names[list_item["name"]] : "fancy_" + list_item["name"],
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
            info = get_conditional_info(list_item, item_names)

            @recipe.add_ingredients(info[:ingredients])
            @recipe.energy = info[:energy]
        
        else

            info = get_conditional_info(list_item,item_names, "normal")
            @recipe.add_ingredients(info[:ingredients])
            @recipe.energy = info[:energy]

            info = get_conditional_info(list_item, item_names, "expensive")
            @recipe.add_expensive_ingredients(info[:ingredients])
            @recipe.energy_expensive = info[:energy]

        end

        @recipe.add_products(info[:products])

        @recipe.save
    end
    @modsuite.save
    puts "Added #{pack}"
end

def get_base()
    build_lua("vendor/factorio/factorio-data", "base", true)
    build_modpack("base")
    move_graphics("base")
end



#make sure the factorio base repo is installed
puts "fatal means success!  Official factorio git is already installed."
`cd vendor/factorio && git clone https://github.com/wube/factorio-data.git`


#Get base mod
get_base()

#get list of folders in factorio/modpacks
packs = Dir.entries("vendor/factorio/modpacks")
packs.each do |pack| #pack dir
    #`rm -rf vendor/factorio/factorio-data/mod`
    
    next if pack == '.' || pack == ".." || pack != "base"
    

    mods = extract_mods(pack)

    ordered_mods = get_mod_order(pack, mods)


    build_lua(pack, ordered_mods)
    move_graphics(pack)
    build_modpack(pack)
    #exit
    #clean up our mess
end

#BuildgraphsJob.perform_now
