local loader = {}

loader.iDIndex = 0
loader.threadCode = [[

require("love.image")
require("love.timer")

local container, channelName, pause = ...

for i, resource in ipairs(container) do
	if resource.type == "IMAGE" then
		resource.rawData = love.image.newImageData(resource.path)
	end
end

love.timer.sleep(pause)

love.thread.getChannel(channelName):push(container)
]]

--- New instance
---@param id? string optional custom ID of thread channel
function loader:new(id)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.ID = id or "Loader" .. tostring(self.iDIndex + 1)

	newInstance.threadContainer = {}
	newInstance.finishCallback = nil
	newInstance.thread = nil
	newInstance.threadStarted = false
	newInstance.isDone = false



	return newInstance
end

function loader:newImage(name, resourcePath)
	table.insert(self.threadContainer, { name = name, path = resourcePath, rawData = nil, type = "IMAGE" })
end

--- Load data asynchronously
---@param finishCallback function Callback function after loading finishes
function loader:loadAsync(finishCallback, pause)
	pause = pause or 0
	self.finishCallback = finishCallback
	Debug:log("[LOADER] Starting new thread " .. self.ID)
	self.thread = love.thread.newThread(self.threadCode)
	self.thread:start(self.threadContainer, self.ID, pause)
	self.threadStarted = true
end

--- Load data synchronously
function loader:loadSync()
	local dataContainer = {}
	for index, resource in ipairs(self.threadContainer) do
		if resource.type == "IMAGE" then
			-- load rawdata and push them into GPU
			table.insert(dataContainer, { name = resource.name, value = love.graphics.newImage(resource.path) })
		end
	end

	--cleaning & finishing
	self.isDone = true

	return dataContainer
end

--- Check if thread is ended
function loader:update(dt)
	if self.thread and self.threadStarted == true then
		if self.thread:isRunning() == true then
			return
		end

		local threadErr = self.thread:getError()
		if threadErr then
			error("Thread error" .. self.threadErr)
		end

		local loadedContainer = love.thread.getChannel(self.ID):pop()

		local dataContainer = {}
		for index, resource in ipairs(loadedContainer) do
			if resource.type == "IMAGE" then
				-- push rawData into GPU				
				table.insert(dataContainer, { name = resource.name, value = love.graphics.newImage(resource.rawData) })
				resource.rawData = nil
			end
		end

		--cleaning & finishing
		self.isDone = true
		self.threadStarted = false
		if self.finishCallback then
			self.finishCallback(dataContainer)
		end

		self.finishCallback = nil

		Debug:log("[LOADER] Thread ended " .. self.ID)
	end
end

return loader
