let action = tiled.registerAction("newMap", function(action) {
    
let brush = tiled.mapEditor.currentBrush;

let worldLayer = new GroupLayer();
worldLayer.name = "World";

brush.addLayer(worldLayer);

});

action.text = "EB_New map";

tiled.extendMenu("Edit", [
    { action: "newMap"},
    { separator: true }
])

