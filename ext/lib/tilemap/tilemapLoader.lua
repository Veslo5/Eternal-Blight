local tileMapLoader = {}

function tileMapLoader:new()
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	-- table
	newInstance.tileMapMetadata = nil
	-- array
	newInstance.tilesetMetadata = {}

	return newInstance
end

--- Loads all tilemaps/tilesets metadata
---@param name string tilemap name
function tileMapLoader:loadMetadata(name)
	local chunk, err = love.filesystem.load(name)

	if err then
		error(err)
	end

	local tileMapMetadata = chunk()

	-- loading all tilesets
	for _, tileset in ipairs(tileMapMetadata.tilesets) do
		local tilesetChunk, err = love.filesystem.load("ext/data/maps/" .. tileset.exportfilename)

		if err then
			error(err)
		end

		table.insert(self.tilesetMetadata, tilesetChunk())
	end

	self.tileMapMetadata = tileMapMetadata
end

--- Return images paths in all tilesets
function tileMapLoader:getResourcesFromTilesets()
	local resourcesTable = {}

	for _, tileset in ipairs(self.tilesetMetadata) do
		table.insert(resourcesTable, { name = tileset.name, image = tileset.image:sub(7) })
	end

	return resourcesTable
end

function tileMapLoader:getTilemapTilesets()
	return self.tileMapMetadata.tilesets
end

function tileMapLoader:getGroupLayer(name)
	for _, layer in ipairs(self.tileMapMetadata.layers) do
		if (layer.type == "group") then
			if (layer.name == name) then
				return layer
			end
		end
	end
	return nil
end

function tileMapLoader:getObjectLayer(name)
	for _, layer in ipairs(self.tileMapMetadata.layers) do
		if (layer.type == "objectgroup") then
			if (layer.name == name) then
				return layer
			end
		end
	end
	return nil
end

function tileMapLoader:unload()
	self.tileMapMetadata = nil
	self.tilesetMetadata = {}
	Debug:log("[CORE] Unloaded tiled tilemap metadata and tileset metadata")
end

return tileMapLoader
