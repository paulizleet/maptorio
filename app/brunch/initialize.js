const cytoscape = require('cytoscape');
//const coseBilkent = require('cytoscape-cose-bilkent');
//const dagre = require('cytoscape-dagre');


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
              'display': (x = data(ncolor)) => {
                    console.log(x.data('ncolor'));
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
          .selector(':selected')
            .css({
              'background-color': 'black',
              'line-color': 'black',
              'target-arrow-color': 'black',
              'source-arrow-color': 'black'
            })
        });
        cy.json(JSON.parse(graph));
        var layout = cy.layout({name: "preset"});
        layout.run();
        console.log("cytoscape ran");
        console.log('Initialized app');
    }
  })  
});


