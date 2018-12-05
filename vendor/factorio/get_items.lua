

-- include factorio's own dataloader to give
-- the "data" object something to work with
require("dataloader")
require("util")
json = require("json")
print("goin")

-- ls the prototypes directory to get a list of the directories beneath
os.execute("ls -1 'prototypes' > directorylist")

-- open that file
local f = io.open("directorylist")


for line in f:lines() do
    -- for each directory, ls it without writing file extensions
    os.execute("ls -1 'prototypes/"..line.."' | sed -e 's/\\..*$//'> itemslist")
    print(line)
    -- open that file
    local g = io.open("itemslist")
    for item in g:lines() do
        --for each  item in this file, require it.
        print(line)
        require("prototypes."..line.."."..item)
    end
end

--getting curse words off my page lol

f.close()

-- turn the accursed data object and turn it into something for normal people
jsonified = json.encode(data.raw["item"])
local f = io.open("items.json", "w")
f:write(jsonified, "\n")
f.close()

-- clean up our mess
os.execute("rm itemslist")