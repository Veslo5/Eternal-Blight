local tileMapRenderer = {}

tileMapRenderer.atlasFactory = require("lib.sprites.atlas")

tileMapRenderer.tileSetAtlases = {}
tileMapRenderer.groupRenderers = {}

tileMapRenderer.fogAtlas = nil
tileMapRenderer.fogBatch = nil


function tileMapRenderer:_convertGIDToLocalIndex(gidIndex, tilesetMetadata)
	local localIndex = gidIndex - IIF(tilesetMetadata.firstgid == 1, 0, tilesetMetadata.firstgid - 1)
	localIndex = IIF(localIndex == 0, 1, localIndex)
	return localIndex
end

--- Get tileset name and index convert from GID to local data index
---@param index integer
---@param tilemapTilesets table
function tileMapRenderer:_getAtlasForTileIndex(index, tilemapTilesets)
	local tilemapTilesetsCount = #tilemapTilesets
	local currentTileset = tilemapTilesets[tilemapTilesetsCount]

	-- first we check if index is from last tilesetAtlas
	if currentTileset.firstgid <= index then
		return currentTileset.name, self:_convertGIDToLocalIndex(index, currentTileset)
	end

	-- then we check all except last
	for i = 1, tilemapTilesetsCount, 1 do
		currentTileset = tilemapTilesets[i]
		if i + 1 <= tilemapTilesetsCount then
			-- check if index is between two max gids
			if currentTileset.firstgid <= index and tilemapTilesets[i + 1].firstgid > index then
				return currentTileset.name, self:_convertGIDToLocalIndex(index, currentTileset)
			end
		end
	end
end

--- Get tileset names from gid data array
---@param tilesData table
---@param tilemapTilesets table
function tileMapRenderer:_getTilesetsNamesAndgidByIndex(tilesData, tilemapTilesets)
	local tilesetNames = {}

	for _, index in ipairs(tilesData) do
		local tilemapTilesetsCount = #tilemapTilesets
		local currentTileset = tilemapTilesets[tilemapTilesetsCount]

		-- first we check if index is from last tilesetAtlas
		if currentTileset.firstgid <= index then
			tilesetNames[currentTileset.name] = { name = currentTileset.name, firstgid = currentTileset.firstgid }
			goto continue
		end

		-- then we check all except last
		for i = 1, tilemapTilesetsCount, 1 do
			currentTileset = tilemapTilesets[i]
			if i + 1 <= tilemapTilesetsCount then
				if currentTileset.firstgid <= index and tilemapTilesets[i + 1].firstgid > index then
					tilesetNames[currentTileset.name] = { name = currentTileset.name, firstgid = currentTileset.firstgid }
					break
				end
			end
		end

		::continue::
	end

	return tilesetNames
end

--- Bakes quads into spritebatches
---@param spriteBatchData table
---@param tilesets table
---@param data table
---@param layerWidth integer
---@param layerHeight integer
---@param tileWidth integer
---@param tileHeight integer
function tileMapRenderer:_bake(spriteBatchData, tilesets, data, layerWidth, layerHeight, tileWidth, tileHeight)
	local layerHeight = layerHeight
	local width = layerWidth - 1
	local height = layerHeight - 1

	for column = 0, width, 1 do
		for row = 0, height, 1 do
			-- + 1 coz lua indexes
			local index = ((row * layerHeight) + column) + 1
			local globaltileNumber = data[index]

			-- 0 is empty tile in Tiled lua export
			if (globaltileNumber ~= 0) then
				local tilesetName, tileIndex = self:_getAtlasForTileIndex(globaltileNumber, tilesets)
				local batchData = table.find(spriteBatchData, "batchTilesetName", tilesetName)

				batchData.spritebatch:add(batchData.atlas.quads[tileIndex], column * tileWidth, row * tileHeight)
			end
		end
	end
end

--- Initialize renderers
---@param tileMapMetadata table metada of tilemap
---@param resources table talbe with resources
function tileMapRenderer:createRenderers(tileMapMetadata, resources)
	-- creating atlas for every tileset
	for _, tileset in ipairs(tileMapMetadata.tilesets) do
		local resource = table.find(resources, "name", tileset.name)
		local atlas = self.atlasFactory:new(resource.value, 32, 32, true)
		atlas:cutQuads()
		self.tileSetAtlases[tileset.name] = atlas
	end

	for _, layer in ipairs(tileMapMetadata.layers) do
		-- check if its folder
		if (layer.type == "group") then
			-- only goto I will EVER use :P! (working as continue statement)
			-- if (layer.name == "Data" and Debug.isOn == false) then goto continue end

			local renderer = {
				name = layer.name,
				spriteBatchesData = {}
			}

			for __, layerInGroup in ipairs(layer.layers) do
				for ___, tilesetName in pairs(self:_getTilesetsNamesAndgidByIndex(layerInGroup.data, tileMapMetadata.tilesets)) do
					-- add spritebatchdata
					table.insert(renderer.spriteBatchesData,
						{
							visible = layerInGroup.visible,
							firstgid = tilesetName.firstgid,
							batchTilesetName = tilesetName.name,
							atlas = self.tileSetAtlases[tilesetName.name],
							layerInGroupName = layerInGroup.name,
							spritebatch = love.graphics.newSpriteBatch(self.tileSetAtlases[tilesetName.name].texture,
							self.tileSetAtlases[tilesetName.name]:getAtlasQuadCount(), "static")
						})
				end

				self:_bake(renderer.spriteBatchesData, tileMapMetadata.tilesets, layerInGroup.data, layerInGroup.width,
				layerInGroup.height, tileMapMetadata.tilewidth, tileMapMetadata.tileheight)
			end

			table.insert(self.groupRenderers, renderer)

			::continue::
		end
	end
end

--- Set spriteBatch layer visibility
---@param name string
---@return boolean
function tileMapRenderer:toggleLayerVisibility(name)
	for _, groupRenderer in ipairs(self.groupRenderers) do
		for __, spritebatchdata in ipairs(groupRenderer.spriteBatchesData) do
			if groupRenderer.name == name then
				spritebatchdata.visible = IIF(spritebatchdata.visible, false, true)
				return true
			end
		end
	end

	return false
end

function tileMapRenderer:draw()
	for _, layerRenderer in ipairs(self.groupRenderers) do
		for __, spritebatchdata in ipairs(layerRenderer.spriteBatchesData) do
			if spritebatchdata.visible then
				love.graphics.draw(spritebatchdata.spritebatch, 0, 0)
			end
		end
	end

	love.graphics.draw(tileMapRenderer.fogBatch, 0, 0)
end

function tileMapRenderer:createFogRenderer(resource, worldData, gridwidth, gridHeight)
	self.fogAtlas = self.atlasFactory:new(resource, 34, 34, true)
	self.fogAtlas:cutQuads()
	self.fogBatch = love.graphics.newSpriteBatch(self.fogAtlas.texture, self.fogAtlas:getAtlasQuadCount(), "dynamic")

	self:bakeFogData(worldData, gridwidth, gridHeight)
end

function tileMapRenderer:bakeFogData(worldData, gridwidth, gridHeight)
	self.fogBatch:clear()
	for x = 1, gridwidth, 1 do
		for y = 1, gridHeight, 1 do
			local tile = worldData[x][y]

			if tile.fog == true then
				self.fogBatch:add(self.fogAtlas.quads[1], ((x - 1) * 32) - 1, ((y - 1) * 32) - 1)
			else
				if tile.playerVisible == false then
					self.fogBatch:add(self.fogAtlas.quads[2], ((x - 1) * 32) - 1, ((y - 1) * 32) - 1)
				end
			end
		end
	end
end

function tileMapRenderer:bakeVisibility()

end

-- function tileMapRenderer.drawWorldWalls(gridWidth, gridHeight, tileWidth, tileHeight, gridData)	
-- 	love.graphics.setColor(1,0,0,0.2)
-- 	for x = 1, gridWidth, 1 do		
-- 		for y = 1, gridHeight, 1 do
-- 			local data = gridData[x][y]
-- 			if data.type == "wall" then
-- 				love.graphics.rectangle("fill", (x - 1)* tileWidth, (y - 1) * tileHeight, tileWidth, tileHeight)
-- 			end
-- 		end
-- 	end
-- 	love.graphics.setColor(1,1,1,1)
-- end

function tileMapRenderer:unload()
	for _, atlas in ipairs(self.tileSetAtlases) do
		atlas:unload()
	end
	self.tileSetAtlases = {}
	Debug:log("[CORE] Unloaded tileset atlases")

	for _, layerRenderer in ipairs(self.groupRenderers) do
		for __, spritebatchdata in ipairs(layerRenderer.spriteBatchesData) do
			spritebatchdata.spritebatch:clear()
			spritebatchdata.spritebatch = nil
			spritebatchdata = nil
		end
		layerRenderer = nil
	end

	self.groupRenderers = {}

	Debug:log("[CORE] Unloaded groupRenderes and spritebatches")
	self.fogBatch:clear()
	self.fogBatch = nil

	self.fogAtlas:unload()
	self.fogAtlas = nil

	Debug:log("[CORE] Unloaded fog atlas and spritebatch")
end

return tileMapRenderer
