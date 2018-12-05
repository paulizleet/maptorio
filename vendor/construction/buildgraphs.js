
var cytoscape = require('cytoscape');
var klay = require('cytoscape-klay')
var fs = require('fs');

var strings = [];
var files = fs.readdirSync("vendor/construction/graphs")
//process.exit(1)
    
files.forEach(element => {
    if(element != "built"){
        console.log(element);
        f = fs.readFileSync("vendor/construction/graphs/" + element,"utf8");
        strings.push(f)
    }
});

cytoscape.use(klay)
var cy = cytoscape({
    headless:false,
    hideLabelsOnViewport: false,

    style: cytoscape.stylesheet()

    .selector('node')
      .css({
        'content': 'data(id)',
        'text-valign': 'center',
        'color': 'white',
        'text-outline-width': 2,
        'background-color': 'data(ncolor)',
        /*'display': (x = data(ncolor)) => {
              console.log(x.data('ncolor'));
              if(x.data('ncolor') == "#00ff00"){
                return "none";
              }else{return "element";}                  
            },*/

        
        'text-outline-color': '#999'
        })
    .selector('edge')
      .css({
        'curve-style': 'haystack',
        'target-arrow-shape': 'triangle',
        'target-arrow-color': '#ccc',
        'line-color': '#ccc',
        'width': 1
      })
    .selector(':selected')
      .css({
        'background-color': 'black',
        'line-color': 'black',
        'target-arrow-color': 'black',
        'source-arrow-color': 'black'
      })})
//console.log(strings)

console.log("cy init")
// For Each Mod Pack
for(var i = 0, len=strings.length; i < len; i++){
    element = strings[i]
    js = JSON.parse(element);

    // Build nodes for each Item in the modpack
    for(var j = 0, jlen = js["items"].length;j < jlen; j++){
        try{
            item = js["items"][j]
            var new_item = cy.add({
                group: "nodes",
                data:{
                    id: "item_"+item["name"],
                    icon: item["icon"],
                    fgroup: item["subgroup"],
                    ncolor: "#ff0000"
                }
            });
            console.log(new_item.data["class"])
        }catch(error){
            console.error(error);
            process.exit(1)
        }
    }
    console.log("items")

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
                id: "recipe_"+recipe["name"],
                cost: cost,
                icon: recipe["icon"],
                category:recipe["category"],
                ingredients: recipe["ingredients"],
                products: recipe["products"],
                fgroup: recipe["subgroup"],
                ncolor: "#00ff00"
            }
        }])

        // Add edges for ingredients
        if(recipe["ingredients"]){
            for(var k = 0, klen = recipe["ingredients"].length;k < klen; k++){
                try{
                    ing = recipe["ingredients"][k]
                    cy.add([{
                            group: "edges",
                            data:{
                                
                                source: "item_" + ing["name"],
                                target: "recipe_" + recipe["name"],
                                quantity: recipe["quantity"]
                             }   
                    }])
                }catch(error){
                    console.error("can't make an edge from ingredient " + ing["name"] + " to " + recipe["name"]);
                    console.error(error)

                    //process.exit(error)
                }
            }
        }


        //Add Edges for Products
        if(recipe["products"]){
            for(var k = 0, klen = recipe["products"].length;k < klen; k++){
                try{
                    var prd = recipe["products"][k]
                    //if(prd["name"] == recipe["name"] && recipe["products"].length == 1){continue}
                    cy.add(
                        {   
                            group: "edges",
                            data:{
                            source: "recipe_"+recipe["name"],
                            target: "item_"+prd["name"],
                            quantity: recipe["quantity"]}
                        }
                    )
            
                }catch(error){
                   console.error("can't make an edge from recipe" + recipe["name"] + " to " + prd["name"]);
                    console.error(error)
                    asdf + 1
                }
            }   
         }
         console.log("recipes")
    }
    var options={   
            name:"klay",
            fit: false,
            klay: {
                direction: "DOWN",
                edgeRouting:"POLYLINE",
                borderSpacing: 0,
                edgeSpacingFactor: .1,
                compactComponents: true,
                compactComponents: true,
                mergeEdges: true,
                nodeLayering: "NETWORK_SIMPLEX",
                nodePlacement: "SIMPLE",
                thoroughness: 20
            }
        }
    console.log("bout 2 run")

    var layout = cy.layout(options)
    console.log("running")

    layout.run()
    //console.log(files[i])

    console.log("ran")
    var graph_str = JSON.stringify(cy.json())

    fs.writeFile("public/graphs/graph_"+files[i], graph_str , (err0rs) => {if(err0rs){console.log(err0rs);throw err0rs}})
    
    return 0
    
}

