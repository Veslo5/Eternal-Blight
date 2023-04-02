--- A dead simple input handling module by Vessyk
-- @module BindMe
local bindMe = {}

bindMe.actionHolder = {}
bindMe.pressedKeys = {}
bindMe.firstPressedKeys = {}
bindMe.pausableActions = {}

bindMe.pauseInput = false

--- Bind action into system
--- @param actionName string binded action name
--- @param inputKeys string[] table with keyboard keys
--- @param pausable? boolean  if action will work even input is disabled
function bindMe:bind(actionName, inputKeys, pausable)
	pausable = pausable ~= false
	if (self.actionHolder[actionName] == nil) then
		self.actionHolder[actionName] = inputKeys
	end

	self.pausableActions[actionName] = pausable
end

--- Check if action is down
--- @param actionName string #name of binded action
function bindMe:isActionDown(actionName)
	-- if (self.actionHolder == nil) then
	--     return false
	-- end

	if self.pauseInput and self.pausableActions[actionName] == true then
		return false
	end

	-- looping through current pressed keys and actions
	for actionKey, actionValue in pairs(self.actionHolder[actionName]) do
		for pressedKey, pressedKeyValue in pairs(self.pressedKeys) do
			if (actionValue == pressedKeyValue) then
				return true
			end
		end
	end

	return false
end

--- Check if action was pressed once
--- @param actionName string #name of binded action
function bindMe:isActionPressed(actionName)
	-- if (self.actionHolder == nil) then
	--     return false
	-- end

	if self.pauseInput and self.pausableActions[actionName] == true then
		return false
	end

	-- looping through current pressed keys and actions
	for actionKey, actionValue in pairs(self.actionHolder[actionName]) do
		for pressedKey, pressedKeyValue in pairs(self.firstPressedKeys) do
			if (actionValue == pressedKey) then
				-- just marking it as already checked
				if (pressedKeyValue == true) then
					self.firstPressedKeys[pressedKey] = false
					return true
				end
			end
		end
	end


	return false
end

--- Check if action is up
--- @param actionName string #name of binded action
function bindMe:isActionUp(actionName)
	if self.PauseInput and self.pausableActions[actionName] == true then
		return false
	end

	if (not self:isActionDown(actionName)) then
		return true
	end
	return false
end

--- KeyPressed callback from LOVE
-- @param key
-- @param scancode
-- @param isrepeat
function bindMe:keyPressed(key, scancode, isrepeat)
	self.pressedKeys[key] = key
	self.firstPressedKeys[key] = true
end

--- KeyRelease callback from LOVE
-- @param key
-- @param scancode
function bindMe:keyRelease(key, scancode)
	self.pressedKeys[key] = nil
	self.firstPressedKeys[key] = nil
end

--- MousePressed callback from LOVE
-- @param x not used
-- @param y not used
-- @param button which button pressed
-- @param istouch
-- @param presses
function bindMe:mousePressed(x, y, button, istouch, presses)
	local mouseButton = "mouse" .. button
	self.pressedKeys[mouseButton] = mouseButton
	self.firstPressedKeys[mouseButton] = true
end

--- MouseReleased callback from LOVE
-- @param x not used
-- @param y not used
-- @param button which button pressed
-- @param istouch
-- @param presses
function bindMe:mouseReleased(x, y, button, istouch, presses)
	local mouseButton = "mouse" .. button
	self.pressedKeys[mouseButton] = nil
	self.firstPressedKeys[mouseButton] = nil;
end

return bindMe
