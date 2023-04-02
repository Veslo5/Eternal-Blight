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

package.path = package.path .. ";./ext/?.lua"
love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";/ext/?.lua")

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

--CONST_SECOND_SCENE = IIF(Debug.IsOn, "debugMenu", "tilemap")
CONST_SECOND_SCENE  = "mapScene"
CONST_INIT_MAP = "ext/data/maps/tutorial_map001.lua"

-- UI constants
CONST_WIDGET_UI_CONSOLA = "UI_WIDGET_CONSOLA"
CONST_WIDGET_UI_TEXTBOX = "UI_WIDGET_TEXTBOX"
CONST_WIDGET_UI_TOOLTIP = "UI_WIDGET_TOOLTIP"

-- Observer constants
CONST_OBSERVE_UI_UPDATE = "UI_UPDATE"
CONST_OBSERVE_UI_DRAW = "UI_DRAW"
CONST_OBSERVE_UI_KEYPRESS= "UI_KEYPRESS"
CONST_OBSERVE_UI_TEXTINPUT= "UI_TEXTINPUT"

CONST_OBSERVE_UI_ADD_CONSOLE_TEXT = "UI_CONSOLE_ADDTEXT"

CONST_OBSERVE_GAMEPLAY_TILE_CHANGED = "GAMEPLAY_TILE_CHANGED"

-- Input constants
CONST_INPUT_EXIT = "EXIT"
CONST_INPUT_CONSOLE = "CONSOLE"
CONST_INPUT_LEFT = "LEFT"
CONST_INPUT_RIGHT = "RIGHT"
CONST_INPUT_UP = "UP"
CONST_INPUT_DOWN = "DOWN"


return Globals