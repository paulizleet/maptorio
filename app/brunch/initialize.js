const cytoscape = require('cytoscape');
const coseBilkent = require('cytoscape-cose-bilkent');
cytoscape.use(coseBilkent)
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

        var cy = cytoscape({
            container: document.getElementById("cy"), 
            headless:false,
            style: [
                {
                    selector: 'node',
                    style: {
                        shape: 'hexagon',
                        'background-color': 'red',
                        label: 'data(id)'
                    }
                }]
            });
        cy.json(JSON.parse(graph));
        var layout = cy.layout({name: 'concentric',
            directed:true,
            avoidOverlap: true,
            roots:["iron-ore", "stone", "uranium-ore"],
            maximalAdjustments: 100});
        layout.run();
        console.log("cytoscape ran")
        console.log('Initialized app');
    }

        })
  // do your setup here
  
});
