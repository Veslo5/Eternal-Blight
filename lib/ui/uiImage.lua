local UIImage = {}

UIImage.ScreenX = 0
UIImage.ScreenY = 0

UIImage.Width = 0
UIImage.Height = 0

UIImage.Resource = nil

UIImage.TextSpacing = 15

UIImage.NodeID = nil

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

	newInstance.NodeID = Observer:Observe(CONST_OBSERVE_UI_DRAW, function() newInstance:Draw() end)	

	return newInstance
end

function UIImage:Draw()
	love.graphics.draw(self.Resource, self.ScreenX, self.ScreenY)
end


function UIImage:Unload()
	self.Resource = nil 
	Observer:StopObserving(CONST_OBSERVE_UI_DRAW, self.NodeID)
	Debug:Log("[UI] Unloaded UI Image " .. self.Name)
end

return UIImage