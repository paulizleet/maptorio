
var cytoscape = require('cytoscape');

var klay = require('cytoscape-klay')
var fs = require('fs');
var strings = [];
var files = fs.readdirSync("vendor/construction/graphs")

var klayOptions = {   
    name:"klay",
    nodeDimensionsIncludeLabels: true,
    fit: true,

    klay: {
        direction: "DOWN",
        edgeRouting:"POLYLINE",
        borderSpacing: 20,
        edgeSpacingFactor: .5,
        compactComponents: false,
        mergeEdges: true,
        nodeLayering: "NETWORK_SIMPLEX",
        nodePlacement: "SIMPLE",
        thoroughness: 20,
        layoutHierarchy: false,
        mergeHierarchyCrossingEdges: true
    },
    stop: function(){
        cy.remove("#ref")
        var graph_str = JSON.stringify(cy.json())   
        fs.writeFile("public/graphs/graph_"+files[i], graph_str , (err0rs) => {if(err0rs){console.log(err0rs);throw err0rs}})  
    }
}
   
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

//Reference node for the kicking algorithm to refer to
//Will be removed before saving
cy.add({
    group: "nodes",
    data:{
        id: "ref",
        force: 3,
        area: null
    }
})

cy.$("#ref").style({display: "none"})
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
                    ncolor: "#ff0000",
                    weight: null
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

        //Recipe Node
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
                                id: "item_" + ing["name"] + "_to_" + "recipe_" + recipe["name"],
                                source: "item_" + ing["name"],
                                target: "recipe_" + recipe["name"],
                                quantity: recipe["quantity"]
                             }   
                    }])
                    /*cy.add([{
                        group: "edges",
                        data:{
                            
                            source: "item_" + ing["name"],
                            target: "recipe" + recipe["name"],
                            quantity: recipe["quantity"]
                         } */  
                
                }catch(error){
                    console.error("can't make an edge from ingredient " + ing["name"] + "_to_" + recipe["name"]);
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
                            id: "recipe_"+recipe["name"] + " to " + "item_"+prd["name"],
                            source: "recipe_"+recipe["name"],
                            target: "item_"+prd["name"],
                            quantity: recipe["quantity"]}
                        }
                    )
                    /*cy.add(
                        {   
                            group: "edges",
                            data:{
                            source: "recipe_"+recipe["name"],
                            target: "recipe"+prd["name"],
                            quantity: recipe["quantity"]}
                        }
                    )*/
            
                }catch(error){
                   console.error("can't make an edge from recipe" + recipe["name"] + " to " + prd["name"]);
                    console.error(error)
                    asdf + 1
                }
            }   
        }
    }


    // Assign a weight of 1 to nodes with no parents, and a big weight to ones with no children
    cy.nodes().each(function(each){
         if(each.incomers().length == 0){
             each.data('weight', 1);
            }
    })

    for(var i = 0; ; i++){
        filtered = cy.nodes().filter(function(e){
            return e.data('weight') == i;
        })

        if(filtered.length == 0){break}

        filtered.outgoers().each(function(e){
            e.data('weight', i+1)
        })
    }
    cy.nodes().sort(function(a, b){
        return a.data('weight') - b.data('weight');
    })

    console.log("bout 2 run")
    var layout = cy.layout(klayOptions)
    console.log("running")

    layout.run()

}