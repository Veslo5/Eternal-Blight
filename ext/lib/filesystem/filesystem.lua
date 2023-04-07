local fileSystemPipeline = {}

fileSystemPipeline.path = "ext/data/"
fileSystemPipeline.mob = "mobs/"
fileSystemPipeline.items = "items/"
fileSystemPipeline.misc = "misc/"
fileSystemPipeline.maps = "maps/"

fileSystemPipeline.extension = ".lua"

fileSystemPipeline.tiledDataFactory = require("ext.lib.filesystem.tiledData")


function fileSystemPipeline:loadTiledData(name)
	local fpath = self.path .. self.maps .. name
	local tilemapMetadata = self._loadTableSafe(fpath)
	local tilesetMetadata = {}

	for _, maptileset in ipairs(tilemapMetadata.tilesets) do
		print(self.path .. self.maps .. maptileset.exportfilename)
		local tileset = self._loadTableSafe(self.path .. self.maps .. maptileset.exportfilename)
		table.insert(tilesetMetadata, tileset)
	end

	return self.tiledDataFactory:new(tilemapMetadata, tilesetMetadata)

end

function fileSystemPipeline:loadItem(name)
	return self._loadTableSafe(self.path .. self.items .. name .. self.extension)
	-- if name:sub(1,1) == "m" then
	-- end
end

function fileSystemPipeline:loadMob(name)
	return self._loadTableSafe(self.path .. self.mob .. name .. self.extension)
end	


function fileSystemPipeline._loadTableSafe(path)	
	local chunk, err = love.filesystem.load(path)
	
	if err then
		error(err)
	end

	-- sandboxing
	local environment = {}
	setfenv(chunk,environment)

	local tableData = chunk()

	if type(tableData) == "table" then
		return tableData
	else
		error("Loaded file is not table!")
	end

end

return fileSystemPipeline