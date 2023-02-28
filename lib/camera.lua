local Camera = {}

--- Constructor
function Camera:New(renderScale, renderMode, virtualResWidth, virtualResHeight)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	-- Render scale in percent!
	newInstance.RenderScale = renderScale or 100

	-- Scale or Fill
	-- Scale is static and defined by renderScale
	-- Fill is dynamic and creating zoom in or our by current resolution
	newInstance.RenderMode = renderMode or "Scale"
	newInstance.VirtualResX = virtualResWidth or 0
	newInstance.VirtualResY = virtualResHeight or 0

	newInstance.X = 0
	newInstance.Y = 0	
	newInstance.Rotation = 0
	newInstance.WindowResX = nil
	newInstance.WindowResY = nil		
	newInstance.ZoomX = 1
	newInstance.ZoomY = 1

	newInstance.OriginX = 0
	newInstance.OriginY = 0
	
	newInstance.MouseWorldX = 0
	newInstance.MouseWorldY = 0
	
	newInstance:_calculateVirtualZoom(newInstance.RenderScaling)

	return newInstance
end

--- Reset the camera into defaults
function Camera:Reset()
	self.X = 0
	self.Y = 0	
	self.Rotation = 0
	self.WindowResX = nil
	self.WindowResY = nil		
	self.ZoomX = 1
	self.ZoomY = 1
	self.VirtualResX = 0
	self.VirtualResY = 0
	self.OriginX = 0
	self.OriginY = 0

	-- Render scale in percent!
	self.RenderScale = 100
end

--- BEGIN DRAWIN OF CAMERA
function Camera:BeginDraw()
	love.graphics.push()
	--love.graphics.rotate(-self.Rotation)	
	love.graphics.scale(self.ZoomX, self.ZoomY)	
	love.graphics.translate(-self.OriginX, -self.OriginY)
	love.graphics.translate(-self.X, -self.Y)

	local mx, my = love.mouse.getPosition()
	self.MouseWorldX, self.MouseWorldY = self:ScreenToWorld(mx, my)

end

--- END DRAWING OF CAMERA
function Camera:EndDraw()
	love.graphics.pop()
end

--- Rotate the camera
function Camera:Rotate(dr)
	self.Rotation = self.Rotation + dr
end

--- Zooms the camera
function Camera:SetZoom(size)
	self.ZoomX = self.ZoomX + size
	self.ZoomY = self.ZoomY + size

	self:_recalculateOrigin()
end

--- Set position of camera
function Camera:SetPosition(x, y)
	self.X = self.X + x
	self.Y = self.Y + y
end

function Camera:ScreenToWorld(mouseX, mouseY)
	return love.graphics.inverseTransformPoint(mouseX, mouseY)
end

function Camera:WorldToScreen(screenX, screenY)
	return love.graphics.transformPoint(screenX, screenY)
end

function Camera:SetRenderScale(renderPercent)
	self.RenderScale = renderPercent
	self:_calculateVirtualZoom()
end

function Camera:Resize(width, height)
	self:_calculateVirtualZoom(self.RenderScale)	
end

function Camera:_calculateVirtualZoom(renderScale)
	local width, height = love.graphics.getDimensions()

	self.WindowResX = width
	self.WindowResY = height

	if (self.RenderMode == "Scale") then
		self.VirtualResX = (self.WindowResX / 100) * self.RenderScale
		self.VirtualResY = (self.WindowResY / 100) * self.RenderScale
	end

	self.ZoomX = width / self.VirtualResX
	self.ZoomY = height / self.VirtualResY

	self:_recalculateOrigin()

end

function Camera:_recalculateOrigin()	
	self.OriginX = self.VirtualResX / 2  - (self.WindowResX / 2) /  self.ZoomX
	self.OriginY = self.VirtualResY / 2  - (self.WindowResY / 2) /  self.ZoomY
end


return Camera