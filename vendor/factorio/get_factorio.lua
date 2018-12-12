
    function errorHandler (error)
        print(error)
        return
    end

    function require_this(path)
    --why
        require(path)
        print("got"..path)
    end

    function deepcopy(orig)
        local orig_type = type(orig)
        local copy
        if orig_type == "table" then
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key)] = deepcopy(orig_value)
            end
            setmetatable(copy, deepcopy(getmetatable(orig)))
        else -- number, string, boolean, etc
            copy = orig
        end
        return copy
    end


    local ppath = package.path

    -- Rewritten after a Dev suggested I use their github repo
    package.path = package.path .. ";vendor/factorio/factorio-data/core/lualib/?.lua"
    package.path = package.path .. ";vendor/factorio/factorio-data/core/?.lua"
    package.path = package.path .. ";vendor/factorio/factorio-data/?"

    package.path = package.path .. ";vendor/factorio/factorio-data/?.lua"
    package.path = package.path .. ";vendor/factorio/factorio-data/?.lua"

    --package.path = package.path .. ";vendor/factorio/factorio-data/base/?.lua"

    settings = {}


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
    require("core.data")

    serpent = require("vendor.factorio.serpent")
    json = require("vendor.factorio.json")
    angelsmods = {}
    bobsmods = {}
    package.path = package.path .. ';vendor/factorio/factorio-data/mod/AngelBobs/?.lua;./?.lua;./?'

print(package.path)
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobenemies/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobinserters/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobtech/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobores/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobplates/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobassembly/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobvehicleequipment/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsrefining/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelspetrochem/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsaddons-warehouses/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsaddons-oresilos/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobmodules/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobmining/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/boblogistics/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobwarfare/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsindustries/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsinfiniteores/?.lua'
xpcall(require_this,errorHandler,'settings')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsaddons-petrotrain/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobenemies/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobinserters/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/boblibrary/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobtech/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobores/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobplates/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobassembly/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobvehicleequipment/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobrevamp/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsrefining/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelspetrochem/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsaddons-pressuretanks/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsaddons-warehouses/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsaddons-oresilos/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobgreenhouse/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobpower/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobelectronics/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobmodules/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobmining/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/boblogistics/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelssmelting/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/bobwarfare/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsbioprocessing/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsindustries/?.lua'
xpcall(require_this,errorHandler,'data')
package.path = ppath .. ';vendor/factorio/factorio-data/mod/AngelBobs/angelsinfiniteores/?.lua'
xpcall(require_this,errorHandler,'data')

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
    f.close()