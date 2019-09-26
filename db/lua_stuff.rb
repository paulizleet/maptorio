#getting rid of bad words in commit messages lol

def build_lua(pack, mods, is_base = false)
        lua_start = '
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

    '
    lua_pt2 = ""
    Dir.entries("vendor/factorio/factorio-data/core/lualib").each do |d|
        next if d == '.' || d == ".." 

        lua_pt2 += "xpcall(require_this, errorHandler, \"vendor.factorio.factorio-data.core.lualib.#{d[0..-5]}\")\n"
    end
    lua_start += lua_pt2

    lua_end =   '



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

        req = /("require\('")/

        luas = ["settings.lua", "settings-updates.lua", "settings-final-fixes.lua", "data.lua", "data-updates.lua", "data-final-fixes.lua"]
        luas.each do |l|
            lua_middle = ""
            if l == "data.lua"
                lua_middle += '
                require("core.data")
                require("base.data")'
            end
            if is_base
                next
            end

            filename = "#{l[0..-5]}".split("-").join()+"_t"
            table_string = "local #{filename} = {"
            mods.each do |m|
                if File.exist?("vendor/factorio/factorio-data/mod/#{pack}/#{m}/#{l}") == true
                    table_string += "{path = \";vendor/factorio/factorio-data/mod/#{pack}/?.lua;vendor/factorio/factorio-data/mod/#{pack}/#{m}/?.lua\", req = '#{m}.#{l[0..-5]}'},"
                end
            end
            next if table_string[-1] == "{"
            lua_middle+= "
                #{table_string}}

                local a = 0
                while a < 5 do

                    local i = 1
                    for i, check in ipairs(#{filename}) do
                        --local check = #{filename}[i]
                        package.path = ppath .. check['path']
                        local pass = xpcall(require_this, errorHandler, check['req'])
                        if pass == true then
                            --table.remove(#{filename}, i)
                        else
                            if i == ##{filename} then
                                --i=1
                            else
                                --i=i+1
                            end
                        end
                    end
                    a=a+1
                end
                if a == 5 then
                    print('skipped some in #{filename}')
                else
                    print('#{filename}')
                end
            "
            
            
            lua_start += lua_middle
        end
        

        # build our lua file
        f = File.new("vendor/factorio/get_factorio.lua", 'w')
        f.write("#{lua_start}#{lua_end}")
        f.close

        # run our lua script in shell
        `lua vendor/factorio/get_factorio.lua >> errors`
        #exit if pack=="base"
end

def extract_mods(pack)
    #Extract all mod data
    zips = Dir.entries("vendor/factorio/modpacks/#{pack}")
    zips.each do |z|
        #binding.pry
        next if z == '.' || z == ".." || z == "base"
        #unzip each zipfile
        zexp = Regexp.new(z[0..-5])
        Zip::File.open("vendor/factorio/modpacks/#{pack}/#{z}") do |f|
            f.each do |e|
                newname = "#{e.name.gsub(zexp, z[0..z.index("_")-1])}"
                e.extract("vendor/factorio/factorio-data/mod/#{pack}/#{newname}")
            end
        end
    end

    #Load all settings for all mods, in natural sort order
    return Dir.entries("vendor/factorio/factorio-data/mod/#{pack}")
end

def get_deps(path)
    f = File.open(path+"/info.json").read
    mods = {}
    json = JSON.parse(f)["dependencies"]
    deps = json.map do |j|

        j.match(/[a-z]\S*/)[0]

    end
end

def sort_mods(mods)
    #first by # dependencies

    keys = mods.keys
    keys.sort! do |a,b|
        mods[a].length <=> mods[b].length
    end
    new_keys = [keys[-1]]
    #reverse sort by dependency, most deps go first
    #push E onto stack
    #move all deps of E after 
    keys.insert(0, "base")
    i = 0
    while true
        swapped = false
        i=0
        while i < keys.length-1 do
            i+=1
            next if mods[keys[i]].length == 1
            k = 0
            mods[keys[i]].each do |kk|
                next if kk == "base"
                a = keys.index {|ak| ak.strip() == kk}
                if a.nil?
                    next
                end
                if a > i
                    keys.insert(i-k, kk)
                    keys.delete_at(keys.rindex(kk))
                    swapped = true
                    k+=1
                end
            end
            i+=1
        end
        break if swapped == false
    end

   # keys.each {|k| puts "#{k} - #{mods[k]}"}
    
    keys


end

def get_mod_order(pack, mods)
    # sort mods by order of dependencies.
    # Base only first, etc etc
    mod_dir = "vendor/factorio/factorio-data/mod/#{pack}/"
    mods_deps = {}
    mods.each do |m|
        next if m == '.' || m == ".." 
        mods_deps.merge!({m=>get_deps(mod_dir+m)})
    end

    infos = sort_mods(mods_deps)

    infos

end