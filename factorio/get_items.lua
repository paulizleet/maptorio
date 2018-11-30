

-- include factorio's own dataloader to give
-- the "data" object something to work with
require("dataloader")
require("util")
json = require("json")

-- ls the recipe module directory without writing file extensions
-- echo it to a file

os.execute("ls -1 'prototypes/item' | sed -e 's/\\..*$//'> itemslist")

-- open that file
local f = io.open("itemslist")

-- for each recipe module, include it so it gets appended to "data"
for line in f:lines() do
    require("prototypes.item."..line)
end
f.close()

-- turn the accursed data object and turn it into something for normal people
jsonified = json.encode(data.raw["item"])
local f = io.open("../items.json", "w")
f:write(jsonified, "\n")
f.close()

-- clean up our mess
os.execute("rm itemslist")