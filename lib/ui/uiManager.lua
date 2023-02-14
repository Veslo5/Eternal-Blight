local UIManager = {}

UIManager.WindowWidth = 0
UIManager.WindowHeight = 0


UIManager.ContainerHolder = {}

function UIManager:Load()
	self.WindowWidth = love.graphics.getWidth()
	self.WindowHeight = love.graphics.getHeight()

	local consolaFactory = require("lib.ui.uiConsola")
	local consola = consolaFactory:New(0, 0, 500, 250)
	self:Align(consola, "left", "bottom")
	
	consola:AddText("First one")
	consola:AddText("Second one...................................")
	consola:AddText("Third one")
	consola:AddText("Fourth one")

	table.insert(self.ContainerHolder, consola)
end


---@alias alignHorizontal
---| '"left"' 
---| '"center"' 
---| '"right"' 
---@alias alignVertical
---| '"top"' 
---| '"center"' 
---| '"bottom"' 


--- Aligns element
---@param uiElement table
---@param alignHorizontal alignHorizontal
---@param alignVertical alignVertical
function UIManager:Align(uiElement, alignHorizontal, alignVertical)
	if alignHorizontal == "left" then
		uiElement.ScreenX = 0
	elseif alignHorizontal == "center" then
		uiElement.ScreenX = (self.WindowWidth / 2) - (uiElement.Width / 2)
	elseif alignHorizontal == "right" then
		uiElement.ScreenX = self.WindowWidth - uiElement.Width
	end

	if alignVertical == "top" then
		uiElement.ScreenY = 0
	elseif alignVertical == "center" then
		uiElement.ScreenY = (self.WindowHeight / 2) - (uiElement.Height / 2)
	elseif alignVertical == "bottom" then
		uiElement.ScreenY = self.WindowHeight - uiElement.Height
	end
end

--TODO: TEXT INPUT
function UIManager:Update(dt)
	for index, value in ipairs(self.ContainerHolder) do
		value:Update(dt)
	end
end

function UIManager:Draw()
	for index, value in ipairs(self.ContainerHolder) do
		value:Draw()
	end
end

function UIManager:Resize(width, height)
	self.WindowWidth = width
	self.WindowHeight = height
end

return UIManager
