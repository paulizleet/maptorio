//const coseBilkent = require('cytoscape-klay');
const dagre = require('cytoscape-dagre');
const cose = require('cytoscape-cose-bilkent')
var klay = require('cytoscape-klay')

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

cytoscape.use(dagre);
cytoscape.use(klay)
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
                'label': 'data(id)',
                'shape': 'rectangle',
                'text-valign': 'bottom',
                'color': 'white',
                'text-outline-width': 2,
                'background-color': 'data(ncolor)',
                'background-image': 'data(icon)',
                'display': (x = data(ncolor)) => {
                      if(x.data('ncolor') == "#00ff00"){
                        return "none";
                      }else{return "element";}                  
                    },
                'text-outline-color': '#999'
                })
            .selector('edge')
              .css({
                'label': 'data(quantity)',
                'text-valign': 'center',
                'color': 'white',
                'text-outline-width': 2,
                'text-opacity': 100,
                'curve-style': 'haystack',
                'target-arrow-shape': 'triangle',
                'target-arrow-color': '#ccc',
                'line-color': '#ccc',
                'width': 3
              })
        
            .selector(".unrelated")
              .css({
                'opacity': .05
              })
            .selector(".related")
              .css({
                'opacity': 1,
                'display': "element"
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
        var layout = cy.layout({
          name: "preset",
          stop:function(){
            cy.minZoom(cy.zoom())

          }});
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


function registerEvents(){

  registerClickHandlers()

  /*TODO:
    Add a number thing to ask how deep to search for parents/children
    Add a tickbox to show other children of parents and how much
  */
}

function registerClickHandlers(){
  cy.on('click', 'node', function(){
    if(cy.scratch("selected") == this){
      deselectNode(this)
    } else {
      selectNode(this)
    }
  })
}

function selectNode(nodes){

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
    console.log("gotcollection")
    cy.batch(function(){
      cy.elements().addClass("unrelated")
    })


    collection.addClass("related")

    cy.scratch({collection: collection, selected: nodes})

    collection.layout({
      name: "dagre",
      nodeDimensionsIncludeLabels: true,
       fit: true
       //directed: true
      }).run()
}

function deselectNode(node){

  console.log("right Clicked");
  succs = node.successors()
  cy.scratch("collection").remove()

  cy.batch(function(){
    cy.elements().removeClass("unrelated")
  })
  resetScratch();  
  //var layout = cy.nodes().layout(klayOptions);
  //layout.run();
  cy.fit()

}

function setScratch(collection, diff, selected){
  cy.scratch({collection: collection,
    diff: diff,
    selected: selected})
}

function resetScratch(){
  setScratch(null, null, null)
}