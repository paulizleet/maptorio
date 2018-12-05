const cytoscape = require('cytoscape');
//const coseBilkent = require('cytoscape-cose-bilkent');
//const dagre = require('cytoscape-dagre');
var klay = require('cytoscape-klay')

cytoscape.use(klay)

var ccbOptions = {
    name: 'cose-bilkent',
    // Called on `layoutready`
    ready: function () {

    },
    // Called on `layoutstop`
    stop: function () {
    },

    // Whether to include labels in node dimensions. Useful for avoiding label overlap
    nodeDimensionsIncludeLabels: true,
    // Whether to fit the network view after when done
    fit: true,
    // Padding on fit
    padding: 10,
    // Whether to enable incremental mode
    randomize: true,

    // Ideal (intra-graph) edge length
    idealEdgeLength: 50,
    // Nesting factor (multiplier) to compute ideal edge length for inter-graph edges
    nestingFactor: 0.1,
    // Gravity force (constant)

    numIter: 10000,
    // Whether to tile disconnected nodes
    tile: true,
    // Type of layout animation. The option set is {'during', 'end', false}
    // Amount of vertical space to put between degree zero nodes during tiling (can also be a function)
    tilingPaddingVertical: 10,
    // Amount of horizontal space to put between degree zero nodes during tiling (can also be a function)
    tilingPaddingHorizontal: 10,
    // Gravity range (constant) for compounds
    };

var dagreOptions = {
    name: "dagre",
    rankDir: "TB",
    ranker: "longest-path",
    fit: "false",
    nodeSep: 1
}

var klayOptions= {
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

var initialization = {
    name: "initialization"
}


    

  

document.addEventListener('DOMContentLoaded', function() {
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
        


        var cy = window.cy = cytoscape({
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
            })
        });

        cy.json(JSON.parse(graph));
        var layout = cy.layout(klayOptions);
        layout.run();
        console.log("cytoscape ran")
        console.log('Initialized app');
    }
  })  
});


