local UIImage = {}



function UIImage:New(name, x, y, resource)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.Name = name
	newInstance.ScreenX = x
	newInstance.ScreenY = y
	newInstance.Width = resource:getWidth()
	newInstance.Height = resource:getHeight()
	newInstance.Resource = resource

	newInstance.Visible = true
	newInstance.NodeID = Observer:Observe(CONST_OBSERVE_UI_DRAW, newInstance.Name, function() newInstance:Draw() end)	

	return newInstance
end

function UIImage:Draw()
	if self.Visible == true then
		love.graphics.draw(self.Resource, self.ScreenX, self.ScreenY)		
	end
end


function UIImage:Unload()	
	Observer:StopObserving(CONST_OBSERVE_UI_DRAW, self.NodeID)
	self.Resource = nil	
	Debug:Log("[UI] Unloaded UI Image " .. self.Name)
end

return UIImage