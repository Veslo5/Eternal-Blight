local UIManager = {}

UIManager.WindowWidth = 0
UIManager.WindowHeight = 0


UIManager.ContainerHolder = {}

function UIManager:Load()
	self.WindowWidth = love.graphics.getWidth()
	self.WindowHeight = love.graphics.getHeight()

	local consolaFactory = require("lib.ui.uiConsola")
	local textBoxFactory = require("lib.ui.uiTextbox")

	local consola = consolaFactory:New(0, 0, 500, 250)
	self:Align(consola, "left", "bottom", 0, 0)
	
	consola:AddText("First one")
	consola:AddText("Second one...................................")
	consola:AddText("Third one")
	consola:AddText("Fourth one")
	
	local consolaTextBox = textBoxFactory:New(0,0,500,30,true)
	self:Align(consolaTextBox, "left", "bottom")
	
	table.insert(self.ContainerHolder, consola)
	table.insert(self.ContainerHolder, consolaTextBox)
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
---@param marginX? integer
---@param marginY? integer
function UIManager:Align(uiElement, alignHorizontal, alignVertical, marginX, marginY)
	marginX = marginX or 0
	marginY = marginY or 0
	if alignHorizontal == "left" then
		uiElement.ScreenX = 0 + marginX
	elseif alignHorizontal == "center" then
		uiElement.ScreenX = ((self.WindowWidth / 2) - (uiElement.Width / 2)) + marginX
	elseif alignHorizontal == "right" then
		uiElement.ScreenX = (self.WindowWidth - uiElement.Width) + marginX
	end

	if alignVertical == "top" then
		uiElement.ScreenY = 0 + marginY
	elseif alignVertical == "center" then
		uiElement.ScreenY = ((self.WindowHeight / 2) - (uiElement.Height / 2)) + marginY
	elseif alignVertical == "bottom" then
		uiElement.ScreenY = (self.WindowHeight - uiElement.Height) + marginY
	end
end

--TODO: TEXT INPUT
function UIManager:Update(dt)
	Observer.trigger(CONST_OBSERVE_UI_UPDATE, dt)
end

function UIManager:Draw()
	Observer.trigger(CONST_OBSERVE_UI_DRAW)
end


function UIManager:KeyPressed(key)
	Observer.trigger(CONST_OBSERVE_UI_KEYPRESS,key)
end

function UIManager:TextInput(text)
	Observer.trigger(CONST_OBSERVE_UI_TEXTINPUT,text)
end

function UIManager:Resize(width, height)
	self.WindowWidth = width
	self.WindowHeight = height
end

return UIManager
