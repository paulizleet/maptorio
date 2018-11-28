module ModsuitesHelper
    # This guy will help when I need to generate new graphs.  
    # He'll write everything into a nice file to serve so I 
    # don't have to generate the map for every request
    require "json"


    def build_graphs
        @ms = Modsuite.all
        mod_stuff = {:items => [], :recipes => []}
        @ms.each do |s|
            mod_stuff[:items] = s.items.all
            mod_stuff[:recipes] = s.recipes.all
            f = File.new("#{@ms.name}.json", "w")
            f.write(JSON.generate(mod_stuff))
            f.close
        end
        `npm graphs.js`
    end


end
