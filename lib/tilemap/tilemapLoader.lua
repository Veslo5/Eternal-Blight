local TileMapLoader = {}

function TileMapLoader:New()
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self 

	-- table
	newInstance.TileMapMetadata = nil
	-- array
	newInstance.TilesetMetadata = {}

	return newInstance
end

--- Loads all tilemaps/tilesets metadata 
---@param name string tilemap name
function TileMapLoader:LoadMetadata(name)	
	local chunk, error = love.filesystem.load(name)    
	local tileMapMetadata = chunk()

	-- loading all tilesets
	for _, tileset in ipairs(tileMapMetadata.tilesets) do
		local tilesetChunk = love.filesystem.load("data/" .. tileset.exportfilename)
		table.insert(self.TilesetMetadata, tilesetChunk())			
	end
	
	self.TileMapMetadata = tileMapMetadata
end

--- Return images paths in all tilesets
function TileMapLoader:GetResourcesFromTilesets()
	local resourcesTable = {}

	for _, tileset in ipairs(self.TilesetMetadata) do
		table.insert(resourcesTable, {name = tileset.name, image = tileset.image:sub(4)})
	end
	
	return resourcesTable
end

function TileMapLoader:GetTilemapTilesets()
	return self.TileMapMetadata.tilesets
end

function TileMapLoader:GetGroupLayer(name)
	for _, layer in ipairs(self.TileMapMetadata.layers) do
		if (layer.type == "group") then
			if (layer.name == name) then
				return layer
			end
		end
	end
	return nil
end

function TileMapLoader:UnloadTileset()
	self.TileMapMetadata = nil
	self.TilesetMetadata = nil
end


return TileMapLoader