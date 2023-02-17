local Globals = {}

Debug = require ("lib.debug.log")
Ecs = require("lib.world.tiny")
Input = require("lib.bindMe")
Tween = require("lib.flux")
Observer = require("lib.beholder")

CONST_OBSERVE_UI_UPDATE = "UI_UPDATE"
CONST_OBSERVE_UI_DRAW = "UI_DRAW"
CONST_OBSERVE_UI_KEYPRESS= "UI_KEYPRESS"
CONST_OBSERVE_UI_TEXTINPUT= "UI_TEXTINPUT"

return Globals