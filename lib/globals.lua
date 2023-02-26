local Globals = {}

--Global objects/modules
local cameraFactory = require("lib.camera")

MainCamera = cameraFactory:New()
UICamera = cameraFactory:New(100, "Fill", 1366, 768)

Debug = require ("lib.debug.log")
Ecs = require("lib.external.tiny")
Timer = require("lib.external.timer")
Tween = require("lib.external.flux")
Input = require("lib.bindMe")
Observer = require("lib.observer")
Utf8 = require("utf8")
Filesystem = require("lib.io.filesystem")
ResourceLoader = require("lib.loader")
Settings = require("lib.settings")


--Global constants
CONST_FIRST_SCENE = "splashScreen"
CONST_SECOND_SCENE = "debugMenu"

-- UI constants
CONST_WIDGET_UI_CONSOLA = "UI_WIDGET_CONSOLA"
CONST_WIDGET_UI_TEXTBOX = "UI_WIDGET_TEXTBOX"

-- Observer constants
CONST_OBSERVE_UI_UPDATE = "UI_UPDATE"
CONST_OBSERVE_UI_DRAW = "UI_DRAW"
CONST_OBSERVE_UI_KEYPRESS= "UI_KEYPRESS"
CONST_OBSERVE_UI_TEXTINPUT= "UI_TEXTINPUT"

CONST_OBSERVE_UI_ADD_CONSOLE_TEXT = "UI_CONSOLE_ADDTEXT"

-- Input constants
CONST_INPUT_EXIT = "EXIT"
CONST_INPUT_CONSOLE = "CONSOLE"
CONST_INPUT_LEFT = "LEFT"
CONST_INPUT_RIGHT = "RIGHT"
CONST_INPUT_UP = "UP"
CONST_INPUT_DOWN = "DOWN"

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