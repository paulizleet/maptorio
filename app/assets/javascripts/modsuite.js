import cytoscape from 'cytoscape';
import coseBilkent from 'cytoscape-cose-bilkent';

cytoscape.use( coseBilkent );
$(document).ready(function(){
    $.ajax({
        url: "/modsuites/" + $('#current_id').val()+"/graph",
        method: "get",
        success: function(graph){

            cytoscape.use( 'cytoscape-cose-bilkent'); // register extension
            console.log("graph was got");  
            cose = cytoscape-cose-bilkent

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