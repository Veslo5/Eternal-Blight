local TileMapRenderer = {}

TileMapRenderer.AtlasFactory = require("lib.sprites.atlas")

TileMapRenderer.TileSetAtlases = {}
TileMapRenderer.GroupRenderers = {}

function TileMapRenderer:GetAtlasForTileIndex(index, tilemapTilesets)
	local tilemapTilesetsCount = #tilemapTilesets
	local currentTileset = tilemapTilesets[tilemapTilesetsCount]
	
	-- first we check if index is from last tilesetAtlas
	if currentTileset.firstgid <= index then
		local indexFromAtlas = index - IIF(currentTileset.firstgid == 1, 0, currentTileset.firstgid - 1)
		indexFromAtlas = IIF(indexFromAtlas == 0, 1, indexFromAtlas)
		return currentTileset.name, indexFromAtlas	
	end

	-- then we check all except last
	for i = 1, tilemapTilesetsCount, 1 do 
		currentTileset = tilemapTilesets[i]
		if i + 1 <= tilemapTilesetsCount then
			if currentTileset.firstgid <= index and tilemapTilesets[i+1].firstgid > index then
				local indexFromAtlas = index - IIF(currentTileset.firstgid == 1, 0, currentTileset.firstgid - 1)
				indexFromAtlas = IIF(indexFromAtlas == 0, 1, indexFromAtlas)
				return currentTileset.name, indexFromAtlas
			end
		end
	end	
end

function TileMapRenderer:GetTilesetsNamesAndgidByIndex(tilesData, tilemapTilesets)
	local tilesetNames = {}

	for _, index in ipairs(tilesData) do
		local tilemapTilesetsCount = #tilemapTilesets
		local currentTileset = tilemapTilesets[tilemapTilesetsCount]

		-- first we check if index is from last tilesetAtlas
		if currentTileset.firstgid <= index then
			tilesetNames[currentTileset.name] = {name = currentTileset.name, firstgid = currentTileset.firstgid}
			goto continue
		end

		-- then we check all except last
		for i = 1, tilemapTilesetsCount, 1 do 
			currentTileset = tilemapTilesets[i]
			if i + 1 <= tilemapTilesetsCount then
				if currentTileset.firstgid  <= index and tilemapTilesets[i+1].firstgid > index then
					tilesetNames[currentTileset.name] = {name = currentTileset.name, firstgid = currentTileset.firstgid}
					break
				end
			end
		end	

		::continue::
	end

	return tilesetNames
end

function TileMapRenderer:Bake(spriteBatchData, tilesets, data, layerWidth, layerHeight, tileWidth, tileHeight)
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
				--TODO TilesetAtlas choose right one
				
				local tilesetName, tileIndex = self:GetAtlasForTileIndex(globaltileNumber, tilesets)
				local batchData = table.find(spriteBatchData, "batchTilesetName", tilesetName)
				batchData.spritebatch:add(batchData.atlas.Quads[tileIndex], column * tileWidth, row * tileHeight)
			end
		end
	end
end

function TileMapRenderer:CreateRenderers(tileMapMetadata, resources)

	-- creating atlas for every tileset
	for _, tileset in ipairs(tileMapMetadata.tilesets) do	
		local resource = table.find(resources, "Name", tileset.name)	
		local atlas = self.AtlasFactory:New(resource.Value, 32, 32, true) 
		atlas:CutQuads()
		self.TileSetAtlases[tileset.name] = atlas
	end

	for _, layer in ipairs(tileMapMetadata.layers) do
		if (layer.type == "group") then

			-- only goto I will EVER use :P! (working as continue statement)
			if (layer.name == "Data" and Debug.IsOn == false) then goto continue end

			local renderer = {
				name = layer.name,
				spriteBatchesData = {}
			}
			
			for __, layerInGroup in ipairs(layer.layers) do
				for ___, tilesetName in pairs(self:GetTilesetsNamesAndgidByIndex(layerInGroup.data, tileMapMetadata.tilesets)) do

					table.insert(renderer.spriteBatchesData, {
						visible = layerInGroup.visible, 
						firstgid = tilesetName.firstgid,
						batchTilesetName = tilesetName.name,
						atlas = self.TileSetAtlases[tilesetName.name],
						layerInGroupName = layerInGroup.name,
						spritebatch = love.graphics.newSpriteBatch(self.TileSetAtlases[tilesetName.name].Texture, self.TileSetAtlases[tilesetName.name]:GetAtlasQuadCount())
					})
				end

					self:Bake(renderer.spriteBatchesData, tileMapMetadata.tilesets, layerInGroup.data, layerInGroup.width, layerInGroup.height, tileMapMetadata.tilewidth, tileMapMetadata.tileheight)

				end
			
			table.insert(self.GroupRenderers, renderer)

			::continue::
		end
	end
end

--- Set spriteBatch layer visibility
---@param name string
---@return boolean
function TileMapRenderer:ToggleLayerVisibility(name)
	for _, groupRenderer in ipairs(self.GroupRenderers) do
		for __, spritebatchdata in ipairs(groupRenderer.spriteBatchesData) do
			if groupRenderer.name == name then
				spritebatchdata.visible = IIF(spritebatchdata.visible, false, true)
				return true
			end
		end
	end

	return false
end

function TileMapRenderer:Draw()
	for _, layerRenderer in ipairs(self.GroupRenderers) do
		for __, spritebatchdata in ipairs(layerRenderer.spriteBatchesData) do
			if spritebatchdata.visible then
			love.graphics.draw(spritebatchdata.spritebatch,0,0)
			end
		end
	end
end

function TileMapRenderer.DrawWorldWalls(gridWidth, gridHeight, tileWidth, tileHeight, gridData)	
	love.graphics.setColor(1,0,0,0.2)
	for x = 1, gridWidth, 1 do		
		for y = 1, gridHeight, 1 do
			local data = gridData[x][y]
			if data.Wall == true then
				love.graphics.rectangle("fill", (x - 1)* tileWidth, (y - 1) * tileHeight, tileWidth, tileHeight)
			end
		end
	end
	love.graphics.setColor(1,1,1,1)
end

function TileMapRenderer:Unload()

	for _, atlas in ipairs(self.TileSetAtlases) do
		atlas:Unload()
	end
	self.TileSetAtlases = {}

	for _, layerRenderer in ipairs(self.GroupRenderers) do
		for __, spritebatchdata in ipairs(layerRenderer.spriteBatchesData) do
			spritebatchdata.spritebatch = nil
			spritebatchdata = nil
		end
		layerRenderer = nil
	end
	
	self.GroupRenderers = {}

end

return TileMapRenderer
