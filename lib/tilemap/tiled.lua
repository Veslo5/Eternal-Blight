local tiled = {}

function tiled:new()
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	tiled.tilemapRenderer = require("lib.tilemap.tilemapRenderer")
	tiled.tilemapLoader = require("lib.tilemap.tilemapLoader"):new()

	return newInstance
end

function tiled:load(mapName, loader)
	self.tilemapLoader:loadMetadata(mapName)

	for _, tilemapImage in ipairs(self.tilemapLoader:getResourcesFromTilesets()) do
		-- adds resources to loading queue
		loader:newImage(tilemapImage.name, tilemapImage.image)
	end

	local data = loader:loadSync()

	self.tilemapRenderer:createRenderers(self.tilemapLoader.tileMapMetadata, data)	
end

function tiled:update(dt)
	if (Input:isActionPressed("DEBUG_WALLS")) then
		self.tilemapRenderer:toggleLayerVisibility("Data")
	end
end

function tiled:draw()
	self.tilemapRenderer:draw()
	--self.tilemapRenderer.drawWorldWalls(world.gridWidth, world.gridHeight, world.tileWidth, world.tileHeight, world.gridData)		
end

function tiled:unload()
	self.tilemapRenderer:unload()
	self.tilemapLoader:unload()
end

return tiled
