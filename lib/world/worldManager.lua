local worldManager = {}

worldManager.currentSelectedTile = nil
worldManager.lastSelectedTile = nil

worldManager.world = require("lib.world.subsystems.world")
worldManager.grid = require("lib.world.subsystems.grid")

worldManager.fogEnabled = false
worldManager.visitedEnabled = true


function worldManager:ecsInit()
	self.world:ecsInit()
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

end

return worldManager
