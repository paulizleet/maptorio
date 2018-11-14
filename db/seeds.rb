require "pry"
#require "rufus-lua"
require "language/lua"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


p Dir.getwd
recipe_files = Dir.entries("factorio/prototypes/recipe")
items = []
lua = Rufus::Lua::State.new

lua_script = "return {"

comma_BD = ""
recipe_files.each do |pth|
    begin
        print(pth)
        f = open("./factorio/prototypes/recipe/#{pth}")
        script = f.read

        script.gsub!(/(data:extend\()/,"")
        script.gsub!(/\)/, "")
        #binding.pry

        lua_script += comma_BD + script[script.index("{")+1..script.rindex("}")-1]
        comma_BD = ", "
    rescue
        next
    end
end
File.new("epiclua.lua","w+" ).write(lua_script+"}")
recipes = lua.eval(lua_script+"}").to_h


p recipes
recipes.each do |a|
    a.each_pair {|k,v| puts "#{k} - #{v}"}
end


