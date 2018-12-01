var cy = require(cytoscape);
var coseBilkent = require(cytoscape-cose-bilkent);
console.log("memes")
cy.use( coseBilkent );
window.onload = function(){
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
            })};