local uIImage = {}

function uIImage:new(name, x, y, resource)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.name = name
	newInstance.screenX = x
	newInstance.screenY = y
	newInstance.width = resource:getWidth()
	newInstance.height = resource:getHeight()
	newInstance.resource = resource

	newInstance.visible = true
	newInstance.nodeID = Observer:observe(CONST_OBSERVE_UI_DRAW, newInstance.name, function() newInstance:draw() end)	

	return newInstance
end

function uIImage:draw()
	if self.visible == true then
		love.graphics.draw(self.resource, self.screenX, self.screenY)		
	end
end


function uIImage:unload()	
	Observer:stopObserving(CONST_OBSERVE_UI_DRAW, self.nodeID)
	self.resource = nil	
	Debug:log("[UI] Unloaded UI Image " .. self.name)
end

return uIImage