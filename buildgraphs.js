
var cytoscape = require('cytoscape');
var fs = require('fs');

var strings = [];

var files = fs.readdirSync("misc/graphs")
    
files.forEach(element => {
    f = fs.readFileSync("misc/graphs/" + element,"utf8");
    strings.push(f)
});

var cy = cytoscape()

//console.log(strings)


// For Each Mod Pack
for(var i = 0, len=strings.length; i < len; i++){
    element = strings[i]
    console.log(element.slice(0,100));
    js = JSON.parse(element);

    // Build nodes for each Item in the modpack
    for(var j = 0, jlen = js["items"].length;j < jlen; j++){
        item = js["items"][j]
        console.log(item);
        var new_item = cy.add({
            group: "nodes",

            data:{
                id: item["name"],
                icon: item["icon"],
                fgroup: item["subgroup"]
            }
        });
    }

    // Build Nodes and edges for each Recipe in the modpack
    for(var j = 0, jlen = js["recipes"].length;j < jlen; j++){
        recipe = js["recipes"][j]
        cost = "normal";
        if(recipe["expensive"] == true){
            cost = "expensive"
        }
        var new_node = cy.add([{
            group: "nodes",
            data:{
                id: recipe["name"],
                cost: cost,
                icon: recipe["icon"],
                category:recipe["category"],
                ingredients: recipe["ingredients"],
                products: recipe["products"],
                fgroup: recipe["subgroup"]
            }
        }])

        //console.log(new_node.json())
        //console.log(new_node.id())

        // Add edges for ingredients
        try{
        for(var k = 0, klen = recipe["ingredients"].length;k < klen; k++){
            ing = recipe["ingredients"][k]
            console.log(ing)
            cy.add(
                {
                    group: "edges",
                    data:{
                    source: ing["name"],
                    target: recipe["name"],
                    quantity: recipe["quantity"]}
                }
            )
        }
        }catch(error){
            console.error("can't make an edge from ingredient" + ing["name"] + " to " + recipe["name"]);
            continue;
        }

        //Add Edges for Products
        if(recipe["products"])
        try{
            for(var k = 0, klen = recipe["products"].length;k < klen; k++){
                var prd = recipe["products"][k]
                //console.log(new_node)
                cy.add(
                    {
                        group: "edges",
                        data:{
                        source: recipe["name"],
                        target: prd["name"],
                        quantity: recipe["quantity"]}
                    }
                )
            }
        }catch(error){
            console.error("can't make an edge from recipe" + recipe["name"] + " to " + prd["name"]);
            continue;
        }
    }
    var options = {
        name:"random"
    }
    
    var layout = cy.layout(options)
    layout.run()
    console.log(element.slice(0,100))
    console.log(files[i])

    var graph_str = JSON.stringify(cy.json())

    fs.writeFile("public/graphs/graph_"+files[i], graph_str , (err0rs) => {if(err0rs){console.log(err0rs);throw err0rs}})
    
    
}

