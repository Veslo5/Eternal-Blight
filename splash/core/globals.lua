local Globals = {}

-- Because you cannot really read next line without headache
-- x = funny == true and "hehe" or "nothehe"

--- Ternary operator - similar to x ? a : b
---@param boolExpression boolean
---@param trueValue any
---@param falseValue any
function IIF (boolExpression, trueValue, falseValue)
	if boolExpression then	return trueValue else return falseValue end
end

--- simple first or default implementation
---@param table table table where find
---@param property any which property find
---@param value any what value to find
---@return any
function table.find(table, property, value)
	for _, object in ipairs(table) do
		if object[property] == value then
			return object
		end
	end

	return nil
end


Debug = require ("splash.core.debug.log")

-- Not working with debugger :/
-- package.path = package.path .. ";./ext/?.lua"
-- love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";/ext/?.lua")

--Global objects/modules
local cameraFactory = require("splash.core.camera")

MainCamera = cameraFactory:new()
UICamera = cameraFactory:new(100, "fill", 1366, 768)

Ecs = require("splash.core.external.tiny")
Timer = require("splash.core.external.timer")
Tween = require("splash.core.external.flux")
Input = require("splash.core.bindMe")
Observer = require("splash.core.observer")
Utf8 = require("utf8")
ResourceLoader = require("splash.core.loader")
Settings = require("splash.core.settings")

return Globals