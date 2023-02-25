local FileSystem = {}

FileSystem.Path = "data/"
FileSystem.Mob = "mobs/"
FileSystem.Items = "items/"

FileSystem.Extension = ".lua"

function FileSystem.LoadItem(name)
	
end

function FileSystem:LoadMob(name)
	return self._loadTableSafe(self.Path .. self.Mob .. name .. self.Extension)
end	


function FileSystem._loadTableSafe(path)
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

return FileSystem