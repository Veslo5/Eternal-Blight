local fileSystem = {}

fileSystem.path = "ext/data/"
fileSystem.mob = "mobs/"
fileSystem.items = "items/"

fileSystem.extension = ".lua"

function fileSystem.loadItem(name)
	
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

	local npcData = chunk()

	if type(npcData) == "table" then
		return npcData
	else
		error("Loaded file is not table!")
	end

end

return fileSystem