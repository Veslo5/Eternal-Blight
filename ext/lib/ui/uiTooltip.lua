local uiToolTip = {}

function uiToolTip:new(name, x, y)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.name = name
	newInstance.screenX = x
	newInstance.screenY = y
	newInstance.width = 200
	newInstance.height = 100

	newInstance.visible = true
	newInstance.text = ""
	newInstance.nodeID = Observer:observe(CONST_OBSERVE_UI_DRAW, newInstance.name, function() newInstance:draw() end)
	newInstance.nodeID2 = Observer:observe(CONST_OBSERVE_GAMEPLAY_TILE_CHANGED, newInstance.name, function(tile)
		if(tile.fog == false) then			
			newInstance.text = "???"
			--newInstance.text = tile.type 
		else
			newInstance.text = "???"
		end
	end)

	return newInstance
end

function uiToolTip:draw()
	if self.visible == true then
		love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
		love.graphics.rectangle("fill", self.screenX, self.screenY, self.width, self.height)
		
		love.graphics.setColor(1,1,1,1)
		love.graphics.print(self.text, self.screenX, self.screenY)
	end
end

function uiToolTip:unload()
	Observer:stopObserving(CONST_OBSERVE_UI_DRAW, self.nodeID)
	Observer:stopObserving(CONST_OBSERVE_GAMEPLAY_TILE_CHANGED, self.nodeID2)
end

return uiToolTip
