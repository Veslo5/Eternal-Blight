local camera = {}

--- Constructor
function camera:new(renderScale, renderMode, virtualResWidth, virtualResHeight)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	-- Render scale in percent!
	newInstance.renderScale = renderScale or 100

	-- Scale or Fill
	-- scale is static and defined by renderScale
	-- fill is dynamic and creating zoom in or our by current resolution
	newInstance.renderMode = renderMode or "scale"
	newInstance.virtualResX = virtualResWidth or 0
	newInstance.virtualResY = virtualResHeight or 0

	newInstance.x = 0
	newInstance.y = 0	
	newInstance.rotation = 0
	newInstance.windowResX = 0
	newInstance.windowResY = 0		
	newInstance.zoomX = 1
	newInstance.zoomY = 1

	newInstance.originX = 0
	newInstance.originY = 0
	
	newInstance.mouseWorldX = 0
	newInstance.mouseWorldY = 0
	
	newInstance:_calculateVirtualZoom(newInstance.windowResX ,newInstance.windowResY)

	return newInstance
end

--- Reset the camera into defaults
function camera:reset()
	self.x = 0
	self.y = 0	
	self.rotation = 0
	self.windowResX = nil
	self.windowResY = nil		
	self.zoomX = 1
	self.zoomY = 1
	self.virtualResX = 0
	self.virtualResY = 0
	self.originX = 0
	self.originY = 0

	-- Render scale in percent!
	self.renderScale = 100
end

--- BEGIN DRAWIN OF CAMERA
function camera:beginDraw()
	love.graphics.push()
	--love.graphics.rotate(-self.Rotation)	
	love.graphics.scale(self.zoomX, self.zoomY)	
	love.graphics.translate(-self.originX, -self.originY)
	love.graphics.translate(-self.x, -self.y)

	local mx, my = love.mouse.getPosition()
	self.mouseWorldX, self.mouseWorldY = self:screenToWorld(mx, my)

end

--- END DRAWING OF CAMERA
function camera:endDraw()
	love.graphics.pop()
end

--- Rotate the camera
function camera:rotate(dr)
	self.rotation = self.rotation + dr
end

--- Zooms the camera
function camera:setZoom(size)
	self.zoomX = self.zoomX + size
	self.zoomY = self.zoomY + size

	self:_recalculateOrigin()
end

--- Set position of camera
function camera:setPosition(x, y)
	self.x = self.x + x
	self.y = self.y + y
end

function camera:screenToWorld(mouseX, mouseY)
	return love.graphics.inverseTransformPoint(mouseX, mouseY)
end

function camera:worldToScreen(screenX, screenY)
	return love.graphics.transformPoint(screenX, screenY)
end

function camera:setRenderScale(renderPercent)
	self.renderScale = renderPercent
	self:_calculateVirtualZoom()
end

function camera:resize(width, height)
	self.windowResX = width
	self.windowResY = height
	self:_calculateVirtualZoom()	
end

function camera:_calculateVirtualZoom()	

	if (self.renderMode == "scale") then
		self.virtualResX = (self.windowResX / 100) * self.renderScale
		self.virtualResY = (self.windowResY / 100) * self.renderScale
	end

	self.zoomX = self.windowResX / self.virtualResX
	self.zoomY = self.windowResY  / self.virtualResY

	self:_recalculateOrigin()

end

function camera:_recalculateOrigin()	
	self.originX = self.virtualResX / 2  - (self.windowResX / 2) /  self.zoomX
	self.originY = self.virtualResY / 2  - (self.windowResY / 2) /  self.zoomY
end


return camera