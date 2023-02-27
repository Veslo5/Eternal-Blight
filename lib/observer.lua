local Observer = {}

Observer.EventsHolder = {}

--- Removes observing
---@param eventName string
---@param nodeId integer
function Observer:StopObserving(eventName, nodeId)
	local indexToRemove = nil
	for index, value in ipairs(self.EventsHolder[eventName]) do
		if value.ID == nodeId then
			indexToRemove = index
			break
		end
	end
	
	if(indexToRemove) then 
	table.remove(self.EventsHolder[eventName], indexToRemove)
	end
end

--- Start observing event
---@param eventName string
---@param callback function
function Observer:Observe(eventName,eventID, callback )
	local node = {}
	node.Callback = callback
	node.ID = eventName .. eventID

	local eventHolder = self.EventsHolder[eventName] or {}
	table.insert(eventHolder, node)

	self.EventsHolder[eventName] = eventHolder

	return node.ID
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
