local worldManager = {}

worldManager.currentSelectedTile = nil
worldManager.lastSelectedTile = nil

worldManager.world = require("ext.lib.world.subsystems.world")
worldManager.grid = require("ext.lib.world.subsystems.grid")
worldManager.filesystem = require("ext.lib.filesystem.filesystem")

worldManager.currentMap = nil
worldManager.tiledData = nil


function worldManager:changeMap(mapName)
	CurrentScene.loading = true	

	if self.currentMap == nil then
		self.tiledData = self.filesystem:loadTiledData(CONST_INIT_MAP)
		mapName = CONST_INIT_MAP
	else
		Debug:log("[CORE] Changing map to " .. mapName)
		self:unload()
		CurrentScene.drawPipeline:unload()
		self.tiledData = self.filesystem:loadTiledData(mapName)
	end

	for _, resource in ipairs(self.tiledData:getResourcesFromTilesets()) do
		CurrentScene.loader:newImage(resource.name, "ext/" .. resource.image)
	end

	
	CurrentScene.loader:newImage("fog","ext/resources/maps/fog.png")

	collectgarbage("collect")

	CurrentScene.loader:loadAsync(worldManager._afterMapResourceLoaded, 1)

	self.currentMap = mapName
	
	
end

function worldManager._afterMapResourceLoaded(resources)
	worldManager:setupMapData(worldManager.tiledData.tileMapMetadata.width,
		worldManager.tiledData.tileMapMetadata.height,
		worldManager.tiledData.tileMapMetadata.tilewidth,
		worldManager.tiledData.tileMapMetadata.tileheight)

	local dataTileGroup = worldManager.tiledData:getGroupLayer("Data")
	local worldObjectGroup = worldManager.tiledData:getObjectLayer("World")

	if (dataTileGroup ~= nil) then
		worldManager.grid:setupWalls(dataTileGroup)
	end

	if worldObjectGroup ~= nil then
		worldManager.world:setupObjects(worldObjectGroup, worldManager.grid)
	end

	CurrentScene.drawPipeline:createTilemapRenderers(worldManager.tiledData.tileMapMetadata, worldManager.grid.gridData, worldManager.grid.gridWidth, worldManager.grid.gridHeight, resources)

	print("[CORE] World map changed: current mapScene textures " .. love.graphics.getStats().images)

	worldManager.world:ecsInit(worldManager)
	worldManager.world:addPlayer()

	CurrentScene.loading = false
end

function worldManager:updateFog(range, currentileX, currentileY)
		
	local fogTiles = self.grid:getDiamondRange(range, currentileX, currentileY)

	for _, tile in ipairs(fogTiles) do
		tile.fog = false
	end

	local visibleTiles = self.grid:getDiamondRange(range - 3, currentileX, currentileY)

	for _, tile in ipairs(visibleTiles) do
		tile.visited = true
	end

	CurrentScene.drawPipeline:bakeFogData(self.grid.gridData, self.grid.gridWidth, self.grid.gridHeight)

	self.grid:forEachTile(function(tile)
		tile.visited = false
	end)
end

function worldManager:createStashEntity()
	local stashEntity = self.entityBuilder:new("Stash")
	stashEntity:addInventory()

	return stashEntity
end

function worldManager:addItem(name)
	local itemData = self.filesystem:loadItem(name)
	local itemEntity = self.entityBuilder:new()
end

function worldManager:addEntity(entity)
	self.world:addEntity(entity)
end

function worldManager:addSystem(system)
	self.world:addSystem(system, self)
end

function worldManager:setupMapData(sizeX, sizeY, tileWidth, tileheight)
	self.grid:setupMapData(sizeX, sizeY, tileWidth, tileheight)
end

function worldManager:getTileGridPosition(worldX, worldY)
	return self.grid:getTileGridPosition(worldX, worldY)
end

function worldManager:getTileWorldPosition(gridX, gridY)
	return self.grid:getTileWorldPosition(gridX, gridY)
end

function worldManager:setWall(onOff, gridX, gridY)
	return self.grid:setWall(onOff, gridX, gridY)
end

function worldManager:getTile(gridX, gridY)
	return self.grid:getTile(gridX, gridY)
end

function worldManager:forEachTile(callback)
	self.grid:forEachTile(callback)
end

function worldManager:getTileNeighbours(tileX, tileY)
	return self.grid:getTileNeighbours(tileX, tileY)
end

function worldManager:isInGridRange(gridX, gridY)
	return self.grid:isInGridRange(gridX, gridY)
end


function worldManager:nextRound()
	self.world:nextRound()
end

function worldManager:update(dt)
	--TODO: Refactor this to function!
	-- should be usable with keyboard too
	-- tiled  changed (mouse)
	local tileworldx, tileworldy = self:getTileGridPosition(MainCamera.mouseWorldX, MainCamera.mouseWorldY)
	self.currentSelectedTile = self:getTile(tileworldx, tileworldy)
	if self.currentSelectedTile ~= self.lastSelectedTile then
		if self.currentSelectedTile then
			self.lastSelectedTile = self.currentSelectedTile
			Observer:trigger(CONST_OBSERVE_GAMEPLAY_TILE_CHANGED, { self.currentSelectedTile })
		end
	end

	--print("Update filter")
	self.world:update(dt)
end

function worldManager:draw()
	--print("Draw filter")
	self.world:draw()
end

function worldManager:unload()
	self.world:unload()
	self.grid:unload()

	self.tiledData:unload()
	self.tiledData = {}

	Debug:log("[GAMEPLAY] Unloaded worldManager")
end

return worldManager
