local fileSystem = {}

fileSystem.path = "ext/data/"
fileSystem.mob = "mobs/"
fileSystem.items = "items/"
fileSystem.misc = "misc/"

fileSystem.extension = ".lua"

function fileSystem:loadItem(name)
	if name:sub(1,1) == "m" then
		return self._loadTableSafe(self.path .. self.items .. self.misc .. self.name)
	end
end

function fileSystem:loadMob(name)
	return self._loadTableSafe(self.path .. self.mob .. name .. self.extension)
end	


function fileSystem._loadTableSafe(path)
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

return fileSystem