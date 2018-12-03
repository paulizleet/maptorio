const cy = require('cytoscape');
const coseBilkent = require('cytoscape-cose-bilkent');
cy.use( coseBilkent );
document.addEventListener('DOMContentLoaded', function() {

  $.ajax({
    url: "/modsuites/" + $('#current_id').val()+"/graph",
    method: "get",
    success: function(graph){

        cy.use(coseBilkent); // register extension
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
        console.log("cytoscape ran")}
        })
  // do your setup here
  console.log('Initialized app');
});
