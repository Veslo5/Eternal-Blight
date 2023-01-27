local WorldManager = {}

WorldManager.MapEntities = {}

WorldManager.GridData = {}
WorldManager.GridWidth = 0
WorldManager.GridHeight = 0
WorldManager.TileWidth = 0
WorldManager.TileHeight = 0

function WorldManager:SetupMapData(sizeX, sizeY, tileWidth, tileheight)
	self.GridWidth = sizeX
	self.GridHeight = sizeY

	self.TileWidth = tileWidth
	self.TileHeight = tileheight

	for x = 1, sizeX, 1 do
		self.GridData[x] = {}
		for y = 1, sizeY, 1 do
			self.GridData[x][y] = { Wall = false }
		end
	end

	Debug:Log("Initialized map data with: " .. self.GridWidth * self.GridHeight .. " tiles")
end

function WorldManager:SetupWalls(dataTiles)
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
						self.GridData[column + 1][row + 1].Wall = true
					end
				end
			end
		end
	end
end

--- Return position of tile in world
---@param gridX integer
---@param gridY integer
function WorldManager:GetTileWorldPosition(gridX, gridY)
	return gridX * self.GridWidth, gridY * self.GridHeight
end

--- Set wall at grid position
---@param onOff boolean
---@param gridX integer
---@param gridY integer
function WorldManager:SetWall(onOff, gridX, gridY)
	self.GridData[gridX][gridY].Wall = onOff
end

--- Returns tile table
---@param gridX integer
---@param gridY integer
---@return table
function WorldManager:GetTile(gridX, gridY)
	return self.GridData[gridX][gridY]
end

--- Checks if parameters are valid values in grid
---@param gridX integer
---@param gridY integer
---@return boolean
function WorldManager:IsInGridRange(gridX, gridY)
	if gridX <= self.GridWidth and gridX > 0 and
		gridY <= self.GridHeight and gridY > 0
	then
		return true
	else
		return false
	end
end

return WorldManager
