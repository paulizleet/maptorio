const coseBilkent = require('cytoscape-klay');
//const dagre = require('cytoscape-dagre');

const cytoscape = require("cytoscape")

var cy = null
var klayOptions = {   
  name:"klay",
  nodeDimensionsIncludeLabels: true,
  fit: true,

  klay: {
      addUnecessaryBendPoints: true,
      direction: "DOWN",
      edgeRouting:"ORTHOGONAL",
      CrossingMinimization: "INTERACTIVE",
      edgeSpacingFactor: 1,
      borderSpacing: 20,
      edgeSpacingFactor: .5,
      compactComponents: true,
      compactComponents: true,
      mergeEdges: false,
      nodeLayering: "LONGEST_PATH",
      nodePlacement: "BRANDES_KOEPF",
      thoroughness: 20,
      randomizationSeed: 0,
      layoutHierarchy: true,
      mergeHierarchyCrossingEdges: true
  }
}  
function modsuite(){
    
//debugger
  $.ajax({
    url: "/modsuites/" + $('#current_id').val()+"/graph",
    method: "get",
    error: function(err){
        console.log(err);
    },
    success: function(graph){
        console.log("graph was got");  
        console.log(graph.slice(0,50))
        cy = window.cy = cytoscape({
          container: document.getElementById("cy"), 
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
                'display': (x = data(ncolor)) => {
                      if(x.data('ncolor') == "#00ff00"){
                        return "none";
                      }else{return "element";}                  
                    },
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
        
            .selector(".unrelated")
              .css({
                'opacity': .05
        
        
              })
            .selector(".related")
              .css({
                'opacity': 1,
              })
            .selector(':selected')
              .css({
                'background-color': 'black',
                'line-color': 'black',
                'target-arrow-color': 'black',
                'source-arrow-color': 'black',
                'opacity': 1,
                "display": "element"
              })
          });
        cy.json(JSON.parse(graph));
        var layout = cy.layout({name: "preset"});
        layout.run();
        console.log("cytoscape ran");
        console.log('Initialized app');

        cy.scratch({"collection":null},{"diff": null},{"selected":null})
        registerEvents()
    }
  })
}

function resetClasses(){
  cy.scratch("diff").forEach(function(each){
    each.removeClass("unrelated")
    each.connectedEdges().forEach(function(e){
      e.removeClass("unrelated")
    })
  })
  cy.scratch({"diff":null})
  cy.scratch("collection").forEach(function(each){
    each.removeClass("related")
  })
  cy.scratch({"collection": null})
}

function unselect(node){

}


function registerEvents(){
  cy.on('click', 'node', function(){


    var nodes = this;

    if(nodes == cy.scratch("selected"))
    {
      unselect(nodes)
      return
    }
    try{
      resetClasses()
    }catch(error){
      console.log("scratch not init'd")
    }
    console.log("cliqq")
    console.log(nodes.data("id"))
    var collection = nodes.successors().union(nodes.predecessors()).merge(nodes)
    
    console.log(collection.length)
    var diff = cy.nodes().difference(collection)
    console.log(diff.length)
    diff.forEach(function(each){
      each.addClass("unrelated")
      each.connectedEdges().forEach(function(e){
        e.addClass("unrelated")
      })
    })

    collection.forEach(function(each){
      each.addClass("related")
    })

    cy.scratch({collection: collection,
                diff: diff,})

    collection.layout({
      name: "breadthfirst",
       fit: true,
       directed: true
      }).run()


  })
  
}