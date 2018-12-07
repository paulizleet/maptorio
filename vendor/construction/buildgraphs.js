
var cytoscape = require('cytoscape');
var euler = require('cytoscape-euler')
var cola = require('cytoscape-cola')
var klay = require('cytoscape-klay')
var fs = require('fs');
var strings = [];
var files = fs.readdirSync("vendor/construction/graphs")

var eulerOptions= {
    name: "euler",

    timeStep: 200,
    animate: false,
    refresh: 100,
    maxIterations: 1000,
    maxSimulationTime: 4000,
    ungrabifyWhileSimulating: true
}

var klayOptions = {   
    name:"klay",
    nodeDimensionsIncludeLabels: true,
    fit: true,

    klay: {
        direction: "DOWN",
        edgeRouting:"POLYLINE",
        borderSpacing: 20,
        edgeSpacingFactor: .5,
        compactComponents: true,
        compactComponents: true,
        mergeEdges: true,
        nodeLayering: "NETWORK_SIMPLEX",
        nodePlacement: "SIMPLE",
        thoroughness: 20,
        layoutHierarchy: true,
        mergeHierarchyCrossingEdges: true
    },
    stop: function(){
        cy.remove("#ref")
        var graph_str = JSON.stringify(cy.json())   
        fs.writeFile("public/graphs/graph_"+files[i], graph_str , (err0rs) => {if(err0rs){console.log(err0rs);throw err0rs}})  
    }
}
var colaOptions={
    name:"cola",
    animate: true,
    refresh:1,
    maxSimulationTime: 2000,
    nodeDimensionsIncludeLabels: true,
    avoidOverlap: true,
    ungrabifyWhileSimulating: true,
    convergenceThreshold: 0.01,
    nodeSpacing: function( node ){ return 50; },
    stop: function(){

        var randomInt = function(max){
            var posneg = 0
            if(Math.random > .5){
                posneg = -1;
            }else{
                posneg = 1
            }
            return Math.floor(Math.random() * Math.floor(max)) * posneg;
        }

        console.log(cy.nodes().boundingBox())
        if(cy.$("#ref").data("force") > 0){
            var strength = cy.$("#ref").data("force")
            console.log("running " + (strength-1))
            cy.nodes().each(function(each){
                //"kick" each node a little bit to knock the graph out of a local minima
                var current = each.position()
                each.position({
                    x: current["x"] + randomInt(strength),
                    y: current["y"] + randomInt(strength)
                })
            
            })
            cy.$("#ref").data("force", strength - 1)
            var layout = cy.layout(colaOptions)        
            layout.run()
        }else{
            cy.remove("#ref")
            console.log("ran")
            var graph_str = JSON.stringify(cy.json())   
            fs.writeFile("public/graphs/graph_"+files[i], graph_str , (err0rs) => {if(err0rs){console.log(err0rs);throw err0rs}})               
        }
    }
}

var breadthFirst = {
    name: 'breadthfirst',

    fit: true, // whether to fit the viewport to the graph
    directed: true, // whether the tree is directed downwards (or edges can point in any direction if false)
    padding: 30, // padding on fit
    circle: false, // put depths in concentric circles if true, put depths top down if false
    grid: true,
    avoidOverlap: true, // prevents node overlap, may overflow boundingBox if not enough space
    nodeDimensionsIncludeLabels: true, // Excludes the label when calculating node bounding boxes for the layout algorithm
    spacingFactor: 10,
    roots:  "#item_iron-ore"
}
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
                                target: "item_" + recipe["name"],
                                quantity: recipe["quantity"]
                             }   
                    }])
                    cy.add([{
                        group: "edges",
                        data:{
                            
                            source: "item_" + ing["name"],
                            target: "item_" + recipe["name"],
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


        /*//Add Edges for Products
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
        }*/
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