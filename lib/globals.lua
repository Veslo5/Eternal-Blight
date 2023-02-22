local Globals = {}

Debug = require ("lib.debug.log")
Ecs = require("lib.world.tiny")
Input = require("lib.bindMe")
Tween = require("lib.flux")
Observer = require("lib.observer")
Utf8 = require("utf8")
Filesystem = require("lib.io.filesystem")

CONST_WIDGET_UI_CONSOLA = "UI_WIDGET_CONSOLA"
CONST_WIDGET_UI_TEXTBOX = "UI_WIDGET_TEXTBOX"

CONST_OBSERVE_UI_UPDATE = "UI_UPDATE"
CONST_OBSERVE_UI_DRAW = "UI_DRAW"
CONST_OBSERVE_UI_KEYPRESS= "UI_KEYPRESS"
CONST_OBSERVE_UI_TEXTINPUT= "UI_TEXTINPUT"

CONST_OBSERVE_UI_ADD_CONSOLE_TEXT = "UI_CONSOLE_ADDTEXT"

CONST_INPUT_EXIT = "EXIT"

-- Because you cannot really read next line without headache
-- x = funny == true and "hehe" or "nothehe"

--- Ternary operator - similar to x ? a : b
---@param boolExpression boolean
---@param trueValue boolean
---@param falseValue boolean
function IIF (boolExpression, trueValue, falseValue)
	if boolExpression then	return trueValue else return falseValue end
end

return Globals