local Globals = {}

Debug = require ("lib.debug.log")
Ecs = require("lib.world.tiny")
Input = require("lib.bindMe")
Tween = require("lib.flux")
Observer = require("lib.observer")
Utf8 = require("utf8")

CONST_OBSERVE_UI_UPDATE = "UI_UPDATE"
CONST_OBSERVE_UI_DRAW = "UI_DRAW"
CONST_OBSERVE_UI_KEYPRESS= "UI_KEYPRESS"
CONST_OBSERVE_UI_TEXTINPUT= "UI_TEXTINPUT"

CONST_OBSERVE_UI_ADD_CONSOLE_TEXT = "UI_CONSOLE_ADDTEXT"

CONST_INPUT_EXIT = "EXIT"

return Globals