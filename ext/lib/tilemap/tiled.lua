local tiled = {}

function tiled:new()
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	-- tiled.tilemapRenderer = require("ext.lib.graphics.tilemapRenderer")
	tiled.tilemapLoader = require("ext.lib.tilemap.tilemapLoader"):new()

	return newInstance
end

function tiled:prepareResourcesForMap(mapName, loader)
	self.tilemapLoader:loadMetadata(mapName)

	for _, tilemapImage in ipairs(self.tilemapLoader:getResourcesFromTilesets()) do
		-- adds resources to loading queue
		loader:newImage(tilemapImage.name, "ext/"..tilemapImage.image)
	end

	loader:newImage("fog","ext/resources/maps/fog.png")
end

function tiled:update(dt)
-- 	if (Input:isActionPressed("DEBUG_WALLS")) then
-- 		self.tilemapRenderer:toggleLayerVisibility("Data")
-- 	end
end

-- function tiled:beginDraw()
-- 	self.tilemapRenderer:beginDraw()
-- 	--self.tilemapRenderer.drawWorldWalls(world.gridWidth, world.gridHeight, world.tileWidth, world.tileHeight, world.gridData)		
-- end
-- function tiled:endDraw()
-- 	self.tilemapRenderer:endDraw()
-- end

function tiled:unload()
	-- self.tilemapRenderer:unload()
	self.tilemapLoader:unload()
end

return tiled
