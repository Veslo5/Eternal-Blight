local Loader = {}

Loader.IDIndex = 0
Loader.ThreadCode = [[

require("love.image")

local container, channelName = ...

for i, resource in ipairs(container) do
	if resource.Type == "IMAGE" then
		resource.RawData = love.image.newImageData(resource.Path)
	end
end

love.thread.getChannel(channelName):push(container)
]]

--- New instance
---@param id? string optional custom ID of thread channel
function Loader:New(id)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self
	
	newInstance.ID = id or "Loader" .. tostring(self.IDIndex + 1)

	newInstance.ThreadContainer = {}		
	newInstance.FinishCallback = nil	
	newInstance.Thread = nil
	newInstance.ThreadStarted = false
	newInstance.IsDone = false
	


	return newInstance
end

function Loader:NewImage(name, resourcePath)
	table.insert(self.ThreadContainer, { Name = name, Path = resourcePath, RawData = nil, Type = "IMAGE" })
end

--- Load data asynchronously
---@param finishCallback function Callback function after loading finishes
function Loader:LoadAsync(finishCallback)
	self.FinishCallback = finishCallback

	Debug:Log("[LOADER] Starting new thread " .. self.ID)
	self.Thread = love.thread.newThread(self.ThreadCode)
	self.Thread:start(self.ThreadContainer, self.ID)
	self.ThreadStarted = true
end

--- Load data synchronously
function Loader:LoadSync()

	local dataContainer = {}
		for index, resource in ipairs(self.ThreadContainer) do
			if resource.Type == "IMAGE" then
				-- load rawdata and push them into GPU
				table.insert(dataContainer, { Name = resource.Name, Value = love.graphics.newImage(resource.Path) })
			end
		end
		
		--cleaning & finishing
		self.IsDone = true

	return dataContainer
end

--- Check if thread is ended
function Loader:Update(dt)
	if self.Thread and self.ThreadStarted == true then
		if self.Thread:isRunning() == true then
			return
		end

		local threadErr = self.Thread:getError()
		if threadErr then
			error("Thread error" .. self.ththreadErr)
		end

		local loadedContainer = love.thread.getChannel(self.ID):pop()

		local dataContainer = {}
		for index, resource in ipairs(loadedContainer) do
			if resource.Type == "IMAGE" then
				-- push rawData into GPU				
				table.insert(dataContainer, { Name = resource.name, Value = love.graphics.newImage(resource.RawData) })
				resource.RawData = nil
			end
		end
		
		--cleaning & finishing
		self.IsDone = true
		self.ThreadStarted = false
		if self.FinishCallback then 
			self.FinishCallback(dataContainer) 
		end
		Debug:Log("[LOADER] Thread ended " .. self.ID)
	end
end

return Loader
