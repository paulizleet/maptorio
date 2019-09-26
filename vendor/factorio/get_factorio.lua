    
    local cli = require("vendor.factorio.clidebugger")
    function errorHandler (error)
        print(error)
        return false
    end

    function require_this(path)
    --why
        require(path)
        print("got "..path)
        return true
    end

    package.path = package.path ..";./?.lua;./?" 


    -- Rewritten after a Dev suggested I use their github repo
    package.path = package.path .. ";vendor/factorio/factorio-data/core/lualib/?.lua"
    package.path = package.path .. ";vendor/factorio/factorio-data/core/?.lua"
    package.path = package.path .. ";vendor/factorio/factorio-data/base/?.lua"
    package.path = package.path .. ";vendor/factorio/factorio-data/?"

    package.path = package.path .. ";vendor/factorio/factorio-data/?.lua"

    --package.path = package.path .. ";vendor/factorio/factorio-data/base/?.lua"
    local ppath = package.path

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
 
    mm = require("mm")
    serpent = require("vendor.factorio.serpent")
    json = require("vendor.factorio.json")
    --require("vendor.factorio.clidebugger")
    xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.util")

    xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.dataloader")

xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.noise")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.story")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.builder")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.camera")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.circuit-connector-generated-definitions")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.mod-gui")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.flying_tags")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.autoplace_utils")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.inspect")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.math3d")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.production-score")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.story-skeleton")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.circuit-connector-sprites")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.silo-script")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.core.lualib.bonus-gui-ordering")
xpcall(require_this, errorHandler, "vendor.factorio.factorio-data.base.data")
pause("fckcuk")


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