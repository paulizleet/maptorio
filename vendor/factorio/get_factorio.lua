
-- Rewritten after a Dev suggested I use their github repo
package.path = package.path .. ";vendor/factorio/?.lua"
package.path = package.path .. ";vendor/factorio/factorio-data/core/lualib/?.lua"
package.path = package.path .. ";vendor/factorio/factorio-data/?"
package.path = package.path .. ";vendor/factorio/factorio-data/base/?.lua"
-- require factorio dataloader and libs
require("dataloader")
require("data")
json = require("json")


--require("core.data")


json = require("json")

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

