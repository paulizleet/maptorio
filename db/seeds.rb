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

# run our lua scripts in shell
`cd factorio && lua get_items.lua`

`cd factorio && lua get_recipes.lua`

f = open("items.json").read

j = JSON.parse(f).to_h

j.each_pair do |key, list_item|

    @item = Item.new(
        name: list_item["name"],
        icon: list_item["icon"],
        subgroup: list_item["subgroup"]
    )
    @item.save
end