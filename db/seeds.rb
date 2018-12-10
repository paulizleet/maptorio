require "pry"
#require "language/lua"
require "json"
require 'zip'
Zip.on_exists_proc = true
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

def build_lua(pack)
    lua_start = '
function errorHandler (error)
    print(error)
    return
end

function require_this(path)
--why
    require(path)
    print("got "..path)
end 


print(package.path)
-- Rewritten after a Dev suggested I use their github repo
package.path = package.path .. ";vendor/factorio/factorio-data/core/lualib/?.lua"
package.path = package.path .. ";vendor/factorio/factorio-data/mod/?.lua"

--package.path = package.path .. ";vendor/factorio/factorio-data/base/?.lua"

defines = {}
defines.difficulty_settings = {}
defines.difficulty_settings.recipe_difficulty = {}
defines.difficulty_settings.recipe_difficulty.normal = 1
defines.difficulty_settings.recipe_difficulty.expensive = 2
defines.difficulty_settings.technology_difficulty = {}
defines.difficulty_settings.technology_difficulty.normal = 1
defines.difficulty_settings.technology_difficulty.expensive = 2
defines.direction = {}
defines.direction.north = 0
defines.direction.east = 1
defines.direction.south = 2
defines.direction.west = 3
function log(x) end


-- require factorio dataloader and libs
require("dataloader")
json = require("vendor.factorio.json")
'

lua_end =   '
print(data.raw["item"])

jsonified = json.encode(data.raw["item"])
local f = io.open("vendor/factorio/items.json", "w")
f:write(jsonified, "\n")
f.close()

jsonified = json.encode(data.raw["fluid"])
local f = io.open("vendor/factorio/fluids.json", "w")
f:write(jsonified, "\n")
f.close()


jsonified = json.encode(data.raw["recipe"])
local f = io.open("vendor/factorio/recipes.json", "w")
f:write(jsonified, "\n")
f.close()'


    lua_middle = ""
    lua_middle += "package.path = package.path .. ';vendor/factorio/factorio-data/mod/#{pack}/?'\n"

    req = /("require\('")/

    zips = Dir.entries("vendor/factorio/modpacks/#{pack}")
    zips.each do |z|
        next if z == '.' || z == ".." || z == "base"
        #unzip each zipfile
        zexp = Regexp.new(z[0..-5])
        Zip::File.open("vendor/factorio/modpacks/#{pack}/#{z}") do |f|
            f.each do |e|
                newname = "#{e.name.gsub(zexp, z[0..z.index("_")-1])}"
                e.extract("vendor/factorio/factorio-data/mod/#{pack}/#{newname}")
            end
            file = File.open("vendor/factorio/factorio-data/mod/#{pack}/#{z[0..z.index("_")-1]}/data.lua")

            file.each_line do |l|
                next if !l.match(/--/).nil? 

                if [/items/,/fluids/, /entities/, /recipe/].all?{|r| l.match(r).nil?}
                    next
                end
                    
    
                splits = l.strip.split("(")
                p splits
                begin
                    lua_middle += "xpcall(#{splits[0][splits[0].index("require")..splits[0].length]+"_this"},'#{pack}.#{z[0..z.index("_")-1]}.#{splits[1][1..splits[1].length-2].gsub(/\"/, "'")}, errorHandler)\n"
                rescue
                    p l
                end


            end

        end
    end

    # build our lua file
    f = File.new("vendor/factorio/get_factorio.lua", 'w')
    f.write("#{lua_start}#{lua_middle}#{lua_end}")
    f.close
    # run our lua script in shell
    `lua vendor/factorio/get_factorio.lua >> errors`
    exit
end


#make sure the factorio base repo is installed
puts "fatal means success!"
`cd vendor/factorio && git clone https://github.com/wube/factorio-data.git`








#get list of folders in factorio/modpacks


packs = Dir.entries("vendor/factorio/modpacks")
packs.each do |pack| #pack dir
    `rm -rf vendor/factorio/factorio/data/mod`

    next if pack == '.' || pack == ".." || pack == "base"
    
    build_lua(pack)
    
    f = open("vendor/factorio/items.json").read

    j = JSON.parse(f).to_h
    
    @modsuite = Modsuite.new(name: pack, description: "Factorio mods :D")

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

    #clean up our mess
end
BuildgraphsJob.perform_now
