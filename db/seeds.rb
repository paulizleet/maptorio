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

# run our lua script in shell
`lua factorio/get_recipes.lua`

f = open("recipes.json").read

j = JSON.parse(f)

p j.first