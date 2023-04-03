local worldManager = {}

worldManager.currentSelectedTile = nil
worldManager.lastSelectedTile = nil

worldManager.world = require("ext.lib.world.subsystems.world")
worldManager.grid = require("ext.lib.world.subsystems.grid")
worldManager.entityBuilder = require("ext.lib.world.entityBuilder")
worldManager.systemBuilder = require("ext.lib.world.systemBuilder")
worldManager.filesystem = require("ext.lib.filesystem.filesystem")

worldManager.currentMap = nil
worldManager.tiledData = nil


function worldManager:changeMap(mapName)
	local loader = ResourceLoader:new()

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
		loader:newImage(resource.name, "ext/" .. resource.image)
	end

	
	loader:newImage("fog","ext/resources/maps/fog.png")

	collectgarbage("collect")

	self:setupMapData(self.tiledData.tileMapMetadata.width,
		self.tiledData.tileMapMetadata.height,
		self.tiledData.tileMapMetadata.tilewidth,
		self.tiledData.tileMapMetadata.tileheight)

	local dataTileGroup = self.tiledData:getGroupLayer("Data")
	local worldObjectGroup = self.tiledData:getObjectLayer("World")

	if (dataTileGroup ~= nil) then
		self:setupWalls(dataTileGroup)
	end

	if worldObjectGroup ~= nil then
		self:setupObjects(worldObjectGroup)
	end

	self:addPlayer()
	self:ecsInit()

	local resources = loader:loadSync()

	CurrentScene.drawPipeline:createTilemapRenderers(self.tiledData.tileMapMetadata, self.grid.gridData, self.grid.gridWidth, self.grid.gridHeight, resources)

	self.currentMap = mapName

	print("[CORE] World map changed: current mapScene textures " .. love.graphics.getStats().images)
end

function worldManager:updateFog(range, currentileX, currentileY)
		
	local fogTiles = self:getDiamondRange(range, currentileX, currentileY)

	for _, tile in ipairs(fogTiles) do
		tile.fog = false
	end

	local visibleTiles = self:getDiamondRange(range - 3, currentileX, currentileY)

	for _, tile in ipairs(visibleTiles) do
		tile.visited = true
	end

	CurrentScene.drawPipeline:bakeFogData(self.grid.gridData, self.grid.gridWidth, self.grid.gridHeight)

	self.grid:forEachTile(function(tile)
		tile.visited = false
	end)
end

function worldManager:ecsInit()
	self:addSystem(self.systemBuilder.getMoveSystem())
	self:addSystem(self.systemBuilder.getDrawSystem())
	self:addSystem(self.systemBuilder.getRoundSystem())

	self.world:ecsInit()
end

function worldManager:addPlayer()
	local playerEntity = self.entityBuilder:new("Player")

	local spawnTile = self:getObjectOfType("spawn")
	if spawnTile then
		playerEntity:makeGridMovable(spawnTile.tile.x - 1, spawnTile.tile.y - 1)
	else
		--TODO: not like this. Every map should have spawn
		playerEntity:makeGridMovable(1, 1)
	end

	playerEntity:makeControllable(true)
	playerEntity:makeDrawable(nil, { 0, 1, 0, 1 })
	playerEntity:makeSimulated(true)
	playerEntity:addStats(1, 10, 10)

	MainCamera:follow(playerEntity.IDrawable, "worldX", "worldY")

	self:addEntity(playerEntity)
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

function worldManager:setupWalls(dataTiles)
	self.grid:setupWalls(dataTiles)
end

function worldManager:setupObjects(worldObjects)
	self.world:setupObjects(worldObjects, self.grid)
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

function worldManager:getDiamondRange(range, tileX, tileY)
	return self.grid:getDiamondRange(range, tileX, tileY)
end

function worldManager:getTileNeighbours(tileX, tileY)
	return self.grid:getTileNeighbours(tileX, tileY)
end

function worldManager:getObjectOfType(type)
	return self.world:getObjectOfType(type)
end

function worldManager:getObjectsOfType(type)
	return self.world:getObjectsOfType(type)
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
