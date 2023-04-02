local systemBuilder = {}

local moveSystem = require("lib.world.systems.moveSystem")
local roundSystem = require("lib.world.systems.roundSystem")
local drawSystem = require("lib.world.systems.drawSytem")

function systemBuilder.getDrawSystem()
	return drawSystem.getSystem()
end

function systemBuilder.getMoveSystem()
	return moveSystem.getSystem()
end

function systemBuilder.getRoundSystem()
	return roundSystem.getSystem()
end

return systemBuilder
