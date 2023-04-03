local tiledData = {}


function tiledData:new(tileMapMetadata, tilesetMetadata)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	-- table
	newInstance.tileMapMetadata = tileMapMetadata
	-- array
	newInstance.tilesetMetadata = tilesetMetadata	

	return newInstance
end

--- Return images paths in all tilesets
function tiledData:getResourcesFromTilesets()
	local resourcesTable = {}

	for _, tileset in ipairs(self.tilesetMetadata) do
		table.insert(resourcesTable, { name = tileset.name, image = tileset.image:sub(7) })
	end

	return resourcesTable
end

function tiledData:getTilemapTilesets()
	return self.tileMapMetadata.tilesets
end

function tiledData:getGroupLayer(name)
	for _, layer in ipairs(self.tileMapMetadata.layers) do
		if (layer.type == "group") then
			if (layer.name == name) then
				return layer
			end
		end
	end
	return nil
end

function tiledData:getObjectLayer(name)
	for _, layer in ipairs(self.tileMapMetadata.layers) do
		if (layer.type == "objectgroup") then
			if (layer.name == name) then
				return layer
			end
		end
	end
	return nil
end

function tiledData:unload()
	self.tileMapMetadata = nil
	self.tilesetMetadata = {}
	Debug:log("[CORE] Unloaded tiled tilemap metadata and tileset metadata")
end

return tiledData