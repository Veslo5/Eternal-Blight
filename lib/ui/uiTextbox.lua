local textbox        = {}

function textbox:new(name, x, y, width, height)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.name = name
	newInstance.screenX = x
	newInstance.screenY = y
	newInstance.width = width
	newInstance.height = height	

	newInstance.focused = false
	newInstance.text = ""

	newInstance.cursorX = 0
	newInstance.defaultfont = love.graphics.getFont()
	Debug:log("[UI] Caution love.graphics.getFont() loads one Image into GPU!")

	newInstance.pastePressed = false

	newInstance.nodeDrawID = Observer:observe(CONST_OBSERVE_UI_DRAW, newInstance.name ,function() newInstance:draw() end)
	newInstance.nodeTextInputID =  Observer:observe(CONST_OBSERVE_UI_TEXTINPUT, newInstance.name, function(text) newInstance:textInput(text) end)
	newInstance.nodeKeypressID = Observer:observe(CONST_OBSERVE_UI_KEYPRESS, newInstance.name, function(key) newInstance:keyPress(key) end)
	newInstance.nodeUpdateID = Observer:observe(CONST_OBSERVE_UI_UPDATE, newInstance.name, function (dt) newInstance:update(dt) end )

	return newInstance
end

function textbox:setFocus(focus)
	self.focused = focus
	Input.pauseInput =  focus
	love.keyboard.setTextInput(focus)
	love.keyboard.setKeyRepeat(focus)

	self.text = ""
	self.cursorX = 0
end

function textbox:getFocus()
	return self.focused
end


function textbox:update(dt)	
	--control + V
	if love.keyboard.isDown("lctrl") and love.keyboard.isDown("v") then
		if self.pastePressed == false then
			self.text = self.text .. love.system.getClipboardText()
			self.cursorX = self.defaultfont:getWidth(self.text)
			self.pastePressed = true
		end
	else
		self.pastePressed = false
	end
end

function textbox:keyPress(key)
	if self.focused == false then
		return
	end
	
	--Removing keys
	if key == "backspace" then
		local byteoffset = Utf8.offset(self.text, -1)
		if byteoffset then
			self.text = string.sub(self.text, 1, byteoffset - 1)
			self.cursorX = self.defaultfont:getWidth(self.text)
		end
	elseif key ==  "return" then
		if Debug.isOn then
			local fn, err = loadstring("return " .. self.text)
			if fn then
				local result = fn()
				Observer:trigger(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, {tostring(result)})
			else
				Observer:trigger(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, {err})
			end
		end
			
		self.text = ""
		self.cursorX = 0
	end
end

function textbox:textInput(text)	
		self.text = self.text .. text
		self.cursorX = self.defaultfont:getWidth(self.text)	
end

function textbox:draw()
	--Background
	love.graphics.setColor(0.1, 0.1, 0.1, 0.5)
	love.graphics.rectangle("fill", self.screenX, self.screenY, self.width, self.height)
	love.graphics.setColor(1, 1, 1)

	--Cursor
	if self.focused then
		love.graphics.rectangle("fill", self.screenX + self.cursorX, self.screenY + self.height - 5, 5, 2)
	end

	--Text
	love.graphics.print(self.text, self.screenX, self.screenY + 10)
end

function textbox:Unload()
	Observer:stopObserving(CONST_OBSERVE_UI_DRAW, self.nodeDrawID)
	Observer:stopObserving(CONST_OBSERVE_UI_TEXTINPUT, self.nodeTextInputID)
	Observer:stopObserving(CONST_OBSERVE_UI_KEYPRESS, self.nodeKeypressID)
	Observer:stopObserving(CONST_OBSERVE_UI_UPDATE, self.nodeUpdateID)
	Debug:log("[UI] Unloaded UI Textbox " .. self.name)

end

return textbox
