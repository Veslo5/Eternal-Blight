local UIManager = {}
UIManager.consolaFactory = require("lib.ui.uiConsola")
UIManager.textBoxFactory = require("lib.ui.uiTextbox")
UIManager.imageFactory = require("lib.ui.uiImage")

UIManager.windowWidth = 0
UIManager.windowHeight = 0

UIManager.ContainerHolder = {}

function UIManager:Load()
	self.windowWidth = love.graphics.getWidth()
	self.windowHeight = love.graphics.getHeight()
	
	love.keyboard.setTextInput(false)
	love.keyboard.setKeyRepeat(false)

end

function UIManager:GetWidget(widgetName)
	return self.ContainerHolder[widgetName]
end

function UIManager:AddConsola(name, x, y ,width ,height, alignHorizontal, alignVertical)
	local consola = self.consolaFactory:New(name ,x, y, width, height)
	
	if(alignHorizontal and alignVertical) then		
		self:Align(consola, alignHorizontal, alignVertical, 0, -31)
	end

	self.ContainerHolder[consola.Name] = consola	
	return consola
end

function UIManager:AddTextBox(name, x, y, width ,height, alignHorizontal, alignVertical)
	local textbox = self.textBoxFactory:New(name,0, 0, 500, 30)
	
	if(alignHorizontal and alignVertical) then		
		self:Align(textbox, "left", "bottom")
	end
	
	self.ContainerHolder[textbox.Name] = textbox

	return textbox

end


function UIManager:AddImage(name, resource, x, y, alignHorizontal, alignVertical)

	local image = self.imageFactory:New(name, x, y, resource)

	if(alignHorizontal and alignVertical) then		
		self:Align(image, alignHorizontal, alignVertical)
	end

	self.ContainerHolder[image.Name] = image
	return image

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

function UIManager:Unload()
	for key, value in pairs(self.ContainerHolder) do
		value:Unload()
	end

	self.ContainerHolder = {}
end

return UIManager
