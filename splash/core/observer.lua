local observer = {}

observer.eventsHolder = {}

--- Removes observing
---@param eventName string
---@param nodeId integer
function observer:stopObserving(eventName, nodeId)
	local indexToRemove = nil
	for index, value in ipairs(self.eventsHolder[eventName]) do
		if value.ID == nodeId then
			indexToRemove = index
			break
		end
	end
	
	if(indexToRemove) then 
	table.remove(self.eventsHolder[eventName], indexToRemove)
	end
end

--- Start observing event
---@param eventName string
---@param callback function
function observer:observe(eventName,eventID, callback )
	local node = {}
	node.callback = callback
	node.ID = eventName .. eventID

	local eventHolder = self.eventsHolder[eventName] or {}
	table.insert(eventHolder, node)

	self.eventsHolder[eventName] = eventHolder

	return node.ID
end

--- Trigger event
---@param eventName string
---@param params? table
function observer:trigger(eventName, params)
	local eventHolder = self.eventsHolder[eventName]

	if eventHolder then
		for index, event in ipairs(eventHolder) do
			if params then
				event.callback(unpack(params))
			else
				event.callback()
			end
		end
	end
end

function observer:unload()
	for _, event in pairs(self.eventsHolder) do
		event = nil
	end
end

return observer
