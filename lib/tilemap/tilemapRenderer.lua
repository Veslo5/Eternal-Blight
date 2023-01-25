local TileMapRenderer = {}

TileMapRenderer.AtlasFactory = require("lib.sprites.atlas")

TileMapRenderer.TileSetAtlas = nil
TileMapRenderer.SpriteBatches = {}



function TileMapRenderer:LoadResources(tilesetMetadata)
	self.TileSetAtlas = self.AtlasFactory:New(tilesetMetadata.image:sub(4), 32, 32, true)
	self.TileSetAtlas:CutQuads()

end

---Manually add spritebatch to rendering
---@param name string
---@param visible boolean
---@param texture love.Texture 
---@param quadCount integer
---@return table 
function TileMapRenderer:AddSpriteBatch (name, visible, texture, quadCount)
	local newBatch = love.graphics.newSpriteBatch(texture, quadCount)
	local groupLayerHolder = {name = name, visible = visible or true, spriteBatch = newBatch}

	table.insert(self.SpriteBatches, groupLayerHolder)
	
	return groupLayerHolder
end

--- Returns spritebatch table
---@param name string
---@return table
function TileMapRenderer:GetSpriteBatchTable(name)
	for _, value in ipairs(self.SpriteBatches) do
		if value.name == name then
			return value
		end
	end

	return nil
end

function TileMapRenderer:RebakeMetaLayer(spriteBatch, layerInGroup, tileWidth, tileHeight)
	local layerHeight = layerInGroup.height
	local width = layerInGroup.width - 1
	local height = layerInGroup.height - 1

	for column = 0, width, 1 do
		for row = 0, height, 1 do
			-- + 1 coz lua indexes
			local index = ((row * layerHeight) + column) + 1
			local tileNumber = layerInGroup.data[index]

			-- 0 is empty tile in Tiled lua export
			if (tileNumber ~= 0) then				
				spriteBatch:add(self.TileSetAtlas.Quads[tileNumber], column * tileWidth, row * tileHeight)
			end
		end
	end
end

function TileMapRenderer:BakeLayers(tileMapMetadata)
	for _, layer in ipairs(tileMapMetadata.layers) do
		if (layer.type == "group") then

			-- only goto I will EVER use :P! (working as continue statement)
			if (layer.name == "Data" and Debug.IsOn == false) then goto continue end

			local currentBatch = self:AddSpriteBatch(layer.name, layer.visible, self.TileSetAtlas.Texture, self.TileSetAtlas:GetAtlasQuadCount()).spriteBatch
			currentBatch:clear()

			for __, layerInGroup in ipairs(layer.layers) do
				self:RebakeMetaLayer(currentBatch, layerInGroup, tileMapMetadata.tilewidth, tileMapMetadata.tileheight)
			end

			currentBatch:flush()

			::continue::
		end
	end
end

--- Set spriteBatch layer visibility
---@param name string
---@return boolean
function TileMapRenderer:ToggleLayerVisibility(name)
	for _, batch in ipairs(self.SpriteBatches) do
		if batch.name == name then
			if (batch.visible == true) then batch.visible = false else batch.visible = true end
			return true
		end
	end
	return false
end

function TileMapRenderer:Draw()
	for _, batch in ipairs(self.SpriteBatches) do
		if batch.visible == true then
			love.graphics.draw(batch.spriteBatch, 0, 0)
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
	self.TileSetAtlas:Unload()
	self.TileSetAtlas = nil

	for _, batch in ipairs(self.SpriteBatches) do
		batch.spriteBatch = nil		
	end

	self.SpriteBatches = nil
	

end

return TileMapRenderer
