local systemBuilder = {}

local moveSystem = require("ext.lib.world.systems.moveSystem")
local roundSystem = require("ext.lib.world.systems.roundSystem")
local drawSystem = require("ext.lib.world.systems.drawSytem")

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
