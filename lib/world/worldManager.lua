local worldManager = {}

worldManager.mapWorld = Ecs.world()

worldManager.drawSystemFilter = nil
worldManager.updateSystemFilter = nil
worldManager.roundSystemFilter = nil

worldManager.currentSelectedTile = nil
worldManager.lastSelectedTile = nil

worldManager.gridObjects = {}

worldManager.gridData = {}
worldManager.gridWidth = 0
worldManager.gridHeight = 0
worldManager.tileWidth = 0
worldManager.tileHeight = 0

worldManager.fogEnabled = false
worldManager.visitedEnabled = true

worldManager.currentRound = 0

function worldManager:ecsInit()
	-- Here we require all DrawSystem marked systems
	self.drawSystemFilter = Ecs.requireAll("drawSystem")
	self.updateSystemFilter = Ecs.requireAll("updateSystem")
	self.roundSystemFilter = Ecs.requireAll("roundSystem")
end

function worldManager:addEntity(entity)
	Ecs.add(self.mapWorld, entity)
end

function worldManager:addSystem(system)
	system.worldManager = self
	Ecs.addSystem(self.mapWorld, system)
	Debug:log("[GAMEPLAY] Added system: " .. system.name)
end

function worldManager:setupMapData(sizeX, sizeY, tileWidth, tileheight)
	self.gridWidth = sizeX
	self.gridHeight = sizeY

	self.tileWidth = tileWidth
	self.tileHeight = tileheight

	for x = 1, sizeX, 1 do
		self.gridData[x] = {}
		for y = 1, sizeY, 1 do
			self.gridData[x][y] = { x = x, y = y, type = "empty", occupied = false, fog = self.fogEnabled, visited = self.visitedEnabled}
		end
	end

	Debug:log("[GAMEPLAY] Initialized map data with: " .. self.gridWidth * self.gridHeight .. " tiles")
end

function worldManager:setupWalls(dataTiles)
	for _, layerInGroup in ipairs(dataTiles.layers) do
		if layerInGroup.name == "Walls" then
			local layerHeight = layerInGroup.height
			local width = layerInGroup.width - 1
			local height = layerInGroup.height - 1


			for column = 0, width, 1 do
				for row = 0, height, 1 do
					-- + 1 coz indexes
					local index = ((row * layerHeight) + column) + 1
					local tileNumber = layerInGroup.data[index]
					if (tileNumber ~= 0) then
						self.gridData[column + 1][row + 1].type = "wall"
					end
				end
			end
		end
	end
end

function worldManager:setupObjects(worldObjects)
	for _, object in ipairs(worldObjects.objects) do
		-- tileset object alignment must be set to top left!
		local tileX, tileY = self:getTileGridPosition(object.x, object.y)
		local tile = self:getTile(tileX, tileY)

		if object.properties["type"] == "port" then
			if tile ~= nil then
				local dataObject = {
					type = "portal",
					map = object.properties["map"],
					tile = tile
				}
				tile.type = "portal"
				tile.map = object.properties["map"]
				table.insert(self.gridObjects, dataObject)
			end
		elseif object.properties["type"] == "spawn" then
			if tile ~= nil then
				local dataObject = {
					type = "spawn",
					tile = tile
				}
				tile.type = "spawn"
				table.insert(self.gridObjects, dataObject)
			end
		end
	end
end

--- Return position of tile in grid
---@param worldX integer
---@param worldY integer
function worldManager:getTileGridPosition(worldX, worldY)
	return math.floor(worldX / self.tileWidth), math.floor(worldY / self.tileHeight)
end

--- Return position of tile in world
---@param gridX integer
---@param gridY integer
function worldManager:getTileWorldPosition(gridX, gridY)
	return gridX * self.gridWidth, gridY * self.gridHeight
end

--- Set wall at grid position
---@param onOff boolean
---@param gridX integer
---@param gridY integer
function worldManager:setWall(onOff, gridX, gridY)
	self.gridData[gridX][gridY].wall = onOff
end

--- Returns tile table
---@param gridX integer
---@param gridY integer
---@return table?
function worldManager:getTile(gridX, gridY)
	-- + 1 because lua indexing starts from 1 and we are using 0 as start in grid
	local tileX = self.gridData[gridX + 1]
	if tileX then
		return tileX[gridY + 1]
	else
		return nil
	end
end

function worldManager:forEachTile(callback)
	for x = 1, self.gridWidth, 1 do
		for y = 1, self.gridHeight, 1 do
			callback(self.gridData[x][y])
		end
	end
end

function worldManager:getDiamondRange(range, tileX, tileY)
	local tilesRef = {}
	self:_getRangeTiles(range, tileX, tileY, tilesRef)
	return tilesRef
end

function worldManager:_getRangeTiles(range, tileX, tileY, dataTilesRef)
	range = range - 1

	if range == 0 then
		return;
	end

	local neighbours = self:getTileNeighbours(tileX, tileY)

	for _, tile in ipairs(neighbours) do
		table.insert(dataTilesRef, tile)
		if tile.type ~= "wall" then
			self:_getRangeTiles(range, tile.x - 1, tile.y - 1, dataTilesRef)
		end
	end
end

function worldManager:getTileNeighbours(tileX, tileY)
	local tiles      = {}
	local leftTile   = self:getTile(tileX - 1, tileY)
	local rightTile  = self:getTile(tileX + 1, tileY)
	local topTile    = self:getTile(tileX, tileY - 1)
	local bottomTile = self:getTile(tileX, tileY + 1)


	if leftTile then
		table.insert(tiles, leftTile)
	end

	if rightTile then
		table.insert(tiles, rightTile)
	end

	if topTile then
		table.insert(tiles, topTile)
	end

	if bottomTile then
		table.insert(tiles, bottomTile)
	end

	return tiles
end

function worldManager:getObjectOfType(type)
	for _, object in pairs(self.gridObjects) do
		if object.type == type then
			return object
		end
	end
	return nil
end

function worldManager:getObjectsOfType(type)
	local objects = {}
	for _, object in pairs(self.gridObjects) do
		if object.type == type then
			table.insert(objects, object)
		end
	end
	return objects
end

--- Checks if parameters are valid values in grid
---@param gridX integer
---@param gridY integer
---@return boolean
function worldManager:isInGridRange(gridX, gridY)
	if gridX <= self.gridWidth and gridX > 0 and
		gridY <= self.gridHeight and gridY > 0
	then
		return true
	else
		return false
	end
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
end

function worldManager:nextRound()
	print("Starting next round")
	self.currentRound = self.currentRound + 1
	Ecs.update(self.mapWorld, love.timer.getDelta(), self.roundSystemFilter)
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
	Ecs.update(self.mapWorld, dt, self.updateSystemFilter)
end

function worldManager:draw()
	--print("Draw filter")
	Ecs.update(self.mapWorld, love.timer.getDelta(), self.drawSystemFilter)
end

function worldManager:unload()
	Ecs.clearEntities(self.mapWorld)
	Ecs.clearSystems(self.mapWorld)
	Debug:log("[CORE] Unloaded ecs entities and systems")
	self.gridData = {}
	Debug:log("[CORE] Unloaded map grid data")
	self.gridObjects = {}
	Debug:log("[CORE] Unloaded grid objects")
end

return worldManager
