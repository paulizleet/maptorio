$(document).ready(function(){
    console.log("fuck")

    $.ajax({
        url: "new",
        method: "post",
        text: "fuckfuck",//$('secretcode').contents(),
            
        success: function(grph){

        var cy = cytoscape();
        cy.json(JSON.parse(graph));
        var layout = cy.layout();
        layout.run();
    }

})
})
