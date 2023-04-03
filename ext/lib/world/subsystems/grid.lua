local grid = {}

grid.gridData = {}
grid.gridWidth = 0
grid.gridHeight = 0
grid.tileWidth = 0
grid.tileHeight = 0

function grid:setupMapData(sizeX, sizeY, tileWidth, tileheight)
	self.gridWidth = sizeX
	self.gridHeight = sizeY

	self.tileWidth = tileWidth
	self.tileHeight = tileheight

	for x = 1, sizeX, 1 do
		self.gridData[x] = {}
		for y = 1, sizeY, 1 do
			self.gridData[x][y] = { x = x, y = y, type = "empty", occupied = false, fog = true, visited = false}
		end
	end

	Debug:log("[GAMEPLAY] Initialized map data with: " .. self.gridWidth * self.gridHeight .. " tiles")
end

function grid:setupWalls(dataTiles)
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

--- Return position of tile in grid
---@param worldX integer
---@param worldY integer
function grid:getTileGridPosition(worldX, worldY)
	return math.floor(worldX / self.tileWidth), math.floor(worldY / self.tileHeight)
end

--- Return position of tile in world
---@param gridX integer
---@param gridY integer
function grid:getTileWorldPosition(gridX, gridY)
	return gridX * self.gridWidth, gridY * self.gridHeight
end

--- Set wall at grid position
---@param onOff boolean
---@param gridX integer
---@param gridY integer
function grid:setWall(onOff, gridX, gridY)
	self.gridData[gridX][gridY].wall = onOff
end

--- Returns tile table
---@param gridX integer
---@param gridY integer
---@return table?
function grid:getTile(gridX, gridY)
	-- + 1 because lua indexing starts from 1 and we are using 0 as start in grid
	local tileX = self.gridData[gridX + 1]
	if tileX then
		return tileX[gridY + 1]
	else
		return nil
	end
end

function grid:forEachTile(callback)
	for x = 1, self.gridWidth, 1 do
		for y = 1, self.gridHeight, 1 do
			callback(self.gridData[x][y])
		end
	end
end

function grid:getDiamondRange(range, tileX, tileY)
	local tilesRef = {}
	self:_getRangeTiles(range, tileX, tileY, tilesRef)
	return tilesRef
end

function grid:_getRangeTiles(range, tileX, tileY, dataTilesRef)
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

function grid:getTileNeighbours(tileX, tileY)
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

--- Checks if parameters are valid values in grid
---@param gridX integer
---@param gridY integer
---@return boolean
function grid:isInGridRange(gridX, gridY)
	if gridX <= self.gridWidth and gridX > 0 and
		gridY <= self.gridHeight and gridY > 0
	then
		return true
	else
		return false
	end
end

function grid:unload()
	self.gridData = {}
	Debug:log("[CORE] Unloaded map grid data")
end

return grid