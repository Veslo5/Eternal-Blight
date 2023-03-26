local uIManager = {}
uIManager.consolaFactory = require("lib.ui.uiConsola")
uIManager.textBoxFactory = require("lib.ui.uiTextbox")
uIManager.imageFactory = require("lib.ui.uiImage")
uIManager.tooltipFactory = require("lib.ui.uiTooltip")

uIManager.windowWidth = 0
uIManager.windowHeight = 0

uIManager.containerHolder = {}

function uIManager:load(resolutionX, resolutionY)
	self.windowWidth = resolutionX
	self.windowHeight = resolutionY
	
	love.keyboard.setTextInput(false)
	love.keyboard.setKeyRepeat(false)

end

function uIManager:getWidget(widgetName)
	return self.containerHolder[widgetName]
end

function uIManager:addConsola(name, x, y ,width ,height, alignHorizontal, alignVertical)
	local consola = self.consolaFactory:new(name ,x, y, width, height)
	
	if(alignHorizontal and alignVertical) then		
		self:align(consola, alignHorizontal, alignVertical, 0, -31)
	end

	self.containerHolder[consola.name] = consola	
	return consola
end

function uIManager:addTextBox(name, x, y, width ,height, alignHorizontal, alignVertical)
	local textbox = self.textBoxFactory:new(name,0, 0, 500, 30)
	
	if(alignHorizontal and alignVertical) then		
		self:align(textbox, "left", "bottom")
	end
	
	self.containerHolder[textbox.name] = textbox

	return textbox

end

function uIManager:addImage(name, resource, x, y, alignHorizontal, alignVertical)
	local image = self.imageFactory:new(name, x, y, resource)

	if(alignHorizontal and alignVertical) then		
		self:align(image, alignHorizontal, alignVertical)
	end

	self.containerHolder[image.name] = image
	return image

end

function uIManager:addToolTip(name, x,y, alignHorizontal, alignVertical)
	local tooltip = self.tooltipFactory:new(name, x, y)

	if(alignHorizontal and alignVertical) then		
		self:align(tooltip, alignHorizontal, alignVertical)
	end

	self.containerHolder[tooltip.name] = tooltip
	return tooltip
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
function uIManager:align(uiElement, alignHorizontal, alignVertical, marginX, marginY)
	marginX = marginX or 0
	marginY = marginY or 0
	if alignHorizontal == "left" then
		uiElement.screenX = 0 + marginX
	elseif alignHorizontal == "center" then
		uiElement.screenX = ((self.windowWidth / 2) - (uiElement.width / 2)) + marginX
	elseif alignHorizontal == "right" then
		uiElement.screenX = (self.windowWidth - uiElement.width) + marginX
	end

	if alignVertical == "top" then
		uiElement.screenY = 0 + marginY
	elseif alignVertical == "center" then
		uiElement.screenY = ((self.windowHeight / 2) - (uiElement.height / 2)) + marginY
	elseif alignVertical == "bottom" then
		uiElement.screenY = (self.windowHeight - uiElement.height) + marginY
	end
end

--TODO: TEXT INPUT
function uIManager:update(dt)
	Observer:trigger(CONST_OBSERVE_UI_UPDATE, { dt })
end

function uIManager:draw()
	Observer:trigger(CONST_OBSERVE_UI_DRAW)
end

function uIManager:keyPressed(key)
	Observer:trigger(CONST_OBSERVE_UI_KEYPRESS, { key })
end

function uIManager:textInput(text)
	Observer:trigger(CONST_OBSERVE_UI_TEXTINPUT, { text })
end


function uIManager:resize(width, height)
	-- self.windowWidth = width
	-- self.windowHeight = height
end

function uIManager:unload()	
	for key, value in pairs(self.containerHolder) do
		value:unload()
	end

	self.containerHolder = {}
end

return uIManager
