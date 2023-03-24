local worldManager = {}

worldManager.mapWorld = Ecs.world()

worldManager.drawSystemFilter = nil
worldManager.updateSystemFilter = nil
worldManager.roundSystemFilter = nil


worldManager.gridData = {}
worldManager.gridWidth = 0
worldManager.gridHeight = 0
worldManager.tileWidth = 0
worldManager.tileHeight = 0

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
			self.gridData[x][y] = { wall = false }
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
						self.gridData[column + 1][row + 1].wall = true
					end
				end
			end
		end
	end
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
	if  tileX then
		return tileX[gridY + 1]
	else
		return nil
	end
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

function worldManager:nextRound()
	print("Starting next round")
	self.currentRound = self.currentRound + 1
	Ecs.update(self.mapWorld, love.timer.getDelta(), self.roundSystemFilter)
end

function worldManager:update(dt)
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

end

return worldManager
