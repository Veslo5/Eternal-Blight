local Observer = {}

Observer.EventsHolder = {}

--- Removes observing
---@param eventName string
---@param nodeId integer
function Observer:StopObserving(eventName, nodeId)
	table.remove(self.EventsHolder[eventName], nodeId)
end

--- Start observing event
---@param eventName string
---@param callback function
---@return integer
function Observer:Observe(eventName, callback)
	local nodeId = 0

	local node = {}
	node.Callback = callback

	local eventHolder = self.EventsHolder[eventName] or {}
	table.insert(eventHolder, node)
	nodeId = #eventHolder

	self.EventsHolder[eventName] = eventHolder


	return nodeId
end

--- Trigger event
---@param eventName string
---@param params? table
function Observer:Trigger(eventName, params)
	local eventHolder = self.EventsHolder[eventName]
	
	if eventHolder then
		for index, event in ipairs(eventHolder) do
			if params then
				event.Callback(unpack(params))
			else
				event.Callback()
			end
		end
	end
end

--TODO: DO Unload!
function Observer:Unload()
	for _, event in pairs(self.EventsHolder) do
		event = nil
	end
end

return Observer
