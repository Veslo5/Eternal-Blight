local TileMapRenderer = {}

TileMapRenderer.AtlasFactory = require("lib.sprites.atlas")

TileMapRenderer.TileSetAtlas = nil
TileMapRenderer.SpriteBatches = {}



function TileMapRenderer:LoadResources(tilesetMetadata)
	self.TileSetAtlas = self.AtlasFactory:New(tilesetMetadata.image, 32, 32, true)
	self.TileSetAtlas:CutQuads()

end

function TileMapRenderer:AddSpriteBatch (name, visible, texture, quadCount)
	local newBatch = love.graphics.newSpriteBatch(texture, quadCount)
	local groupLayerHolder = {name = name, visible = visible or true, spriteBatch = newBatch}

	table.insert(self.SpriteBatches, groupLayerHolder)
	
	return groupLayerHolder
end


function TileMapRenderer:GetSpriteBatchTable(name)
	for _, value in ipairs(self.SpriteBatches) do
		if value.name == name then
			return value
		end
	end
end


function TileMapRenderer:BakeLayers(tileMapMetadata)
	for _, layer in ipairs(tileMapMetadata.layers) do
		if (layer.type == "group") then

			-- only goto I will EVER use :P! (working as continue statement)
			if (layer.name == "Data" and Debug.IsOn == false) then goto continue end

			local groupLayerHolder = { name = layer.name, visible = layer.visible }

			local currentBatch = love.graphics.newSpriteBatch(self.TileSetAtlas.Texture, self.TileSetAtlas:GetAtlasQuadCount())
			currentBatch:clear()

			groupLayerHolder.spriteBatch = currentBatch
			table.insert(self.SpriteBatches, groupLayerHolder)

			for __, layerInGroup in ipairs(layer.layers) do

				local layerHeight = layerInGroup.height
				local width = layerInGroup.width - 1
				local height = layerInGroup.height - 1

				for column = 0, width, 1 do
					for row = 0, height, 1 do
						-- + 1 coz indexes
						local index = ((row * layerHeight) + column) + 1
						local tileNumber = layerInGroup.data[index]

						if (tileNumber ~= 0) then
							--print(layer.name, layerInGroup.name, tileNumber, column * 32, row * 32)
							currentBatch:add(self.TileSetAtlas.Quads[tileNumber], column * 32, row * 32)
						end
					end
				end
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

function TileMapRenderer.UnloadResources()

end

return TileMapRenderer
