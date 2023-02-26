local Textbox        = {}

Textbox.Focused = false
Textbox.ScreenX      = 0
Textbox.ScreenY      = 0
Textbox.Width        = 0
Textbox.Height       = 0

Textbox.Text         = ""

Textbox.CursorX      = 0
Textbox.Defaultfont = love.graphics.getFont()
Debug:Log("[UI] Caution love.graphics.getFont() loads one Image into GPU!")

Textbox.pastePressed = false

Textbox.NodeDrawID = nil
Textbox.NodeTextInputID = nil
Textbox.NodeKeypressID = nil
Textbox.NodeUpdateID = nil


function Textbox:New(name, x, y, width, height)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.Name = name
	newInstance.ScreenX = x
	newInstance.ScreenY = y
	newInstance.Width = width
	newInstance.Height = height	

	newInstance.NodeDrawID = Observer:Observe(CONST_OBSERVE_UI_DRAW, function() newInstance:Draw() end)
	newInstance.NodeTextInputID =  Observer:Observe(CONST_OBSERVE_UI_TEXTINPUT, function(text) newInstance:TextInput(text) end)
	newInstance.NodeKeypressID = Observer:Observe(CONST_OBSERVE_UI_KEYPRESS, function(key) newInstance:KeyPress(key) end)
	newInstance.NodeUpdateID = Observer:Observe(CONST_OBSERVE_UI_UPDATE, function (dt) newInstance:Update(dt) end )

	return newInstance
end

function Textbox:SetFocus(focus)
	self.Focused = focus
	Input.PauseInput =  focus
	love.keyboard.setTextInput(focus)
	love.keyboard.setKeyRepeat(focus)

	self.Text = ""
	self.CursorX = 0
end

function Textbox:GetFocus()
	return self.Focused
end


function Textbox:Update(dt)	
	--control + V
	if love.keyboard.isDown("lctrl") and love.keyboard.isDown("v") then
		if self.pastePressed == false then
			self.Text = self.Text .. love.system.getClipboardText()
			self.CursorX = self.Defaultfont:getWidth(self.Text)
			self.pastePressed = true
		end
	else
		self.pastePressed = false
	end
end

function Textbox:KeyPress(key)
	if self.Focused == false then
		return
	end
	
	--Removing keys
	if key == "backspace" then
		local byteoffset = Utf8.offset(self.Text, -1)
		if byteoffset then
			self.Text = string.sub(self.Text, 1, byteoffset - 1)
			self.CursorX = self.Defaultfont:getWidth(self.Text)
		end
	elseif key ==  "return" then
		if Debug.IsOn then
			local fn, err = loadstring("return " .. self.Text)
			if fn then
				local result = fn()
				Observer:Trigger(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, {tostring(result)})
			else
				Observer:Trigger(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, {err})
			end
		end
			
		self.Text = ""
		self.CursorX = 0
	end
end

function Textbox:TextInput(text)	
		self.Text = self.Text .. text
		self.CursorX = self.Defaultfont:getWidth(self.Text)	
end

function Textbox:Draw()
	--Background
	love.graphics.setColor(0.1, 0.1, 0.1, 0.5)
	love.graphics.rectangle("fill", self.ScreenX, self.ScreenY, self.Width, self.Height)
	love.graphics.setColor(1, 1, 1)

	--Cursor
	if self.Focused then
		love.graphics.rectangle("fill", self.ScreenX + self.CursorX, self.ScreenY + self.Height - 5, 5, 2)
	end

	--Text
	love.graphics.print(self.Text, self.ScreenX, self.ScreenY + 10)
end

function Textbox:Unload()
	Observer:StopObserving(CONST_OBSERVE_UI_DRAW, self.NodeDrawID)
	Observer:StopObserving(CONST_OBSERVE_UI_TEXTINPUT, self.NodeTextInputID)
	Observer:StopObserving(CONST_OBSERVE_UI_KEYPRESS, self.NodeKeypressID)
	Observer:StopObserving(CONST_OBSERVE_UI_UPDATE, self.NodeUpdateID)
	Debug:Log("[UI] Unloaded UI Textbox " .. self.Name)

end

return Textbox
