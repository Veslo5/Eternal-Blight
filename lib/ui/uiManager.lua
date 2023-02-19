local UIManager = {}
UIManager.consolaFactory = require("lib.ui.uiConsola")
UIManager.textBoxFactory = require("lib.ui.uiTextbox")

UIManager.windowWidth = 0
UIManager.windowHeight = 0

UIManager.ContainerHolder = {}

function UIManager:Load()
	self.windowWidth = love.graphics.getWidth()
	self.windowHeight = love.graphics.getHeight()
	
	love.keyboard.setTextInput(false)
	love.keyboard.setKeyRepeat(false)

	local consola = self.consolaFactory:New(CONST_WIDGET_UI_CONSOLA,0, 0, 500, 250)
	self:Align(consola, "left", "bottom", 0, -31)

	local consolaTextBox = self.textBoxFactory:New(CONST_WIDGET_UI_TEXTBOX,0, 0, 500, 30)
	self:Align(consolaTextBox, "left", "bottom")

	self.ContainerHolder[consola.Name] = consola
	self.ContainerHolder[consolaTextBox.Name] = consolaTextBox
end

function UIManager:GetWidget(widgetName)
	return self.ContainerHolder[widgetName]
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
		uiElement.ScreenX = ((self.windowWidth / 2) - (uiElement.Width / 2)) + marginX
	elseif alignHorizontal == "right" then
		uiElement.ScreenX = (self.windowWidth - uiElement.Width) + marginX
	end

	if alignVertical == "top" then
		uiElement.ScreenY = 0 + marginY
	elseif alignVertical == "center" then
		uiElement.ScreenY = ((self.windowHeight / 2) - (uiElement.Height / 2)) + marginY
	elseif alignVertical == "bottom" then
		uiElement.ScreenY = (self.windowHeight - uiElement.Height) + marginY
	end
end

--TODO: TEXT INPUT
function UIManager:Update(dt)
	Observer:Trigger(CONST_OBSERVE_UI_UPDATE, { dt })
end

function UIManager:Draw()
	Observer:Trigger(CONST_OBSERVE_UI_DRAW)
end

function UIManager:KeyPressed(key)
	Observer:Trigger(CONST_OBSERVE_UI_KEYPRESS, { key })
end

function UIManager:TextInput(text)
	Observer:Trigger(CONST_OBSERVE_UI_TEXTINPUT, { text })
end


function UIManager:Resize(width, height)
	self.windowWidth = width
	self.windowHeight = height
end

return UIManager
