/*$(document).ready(function(){
    $.ajax({
        url: "/modsuites/" + $('#current_id').val()+"/graph",
        method: "get",
        success: function(graph){
            var cy = cytoscape({
                container: $("#cy"), 
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
            var layout = cy.layout({name: 'preset'});
            layout.run();
            console.log("cytoscape ran")
        }
    })
})*/
