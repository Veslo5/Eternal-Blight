local tiled = {}

function tiled:new()
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	tiled.tilemapRenderer = require("lib.tilemap.tilemapRenderer")
	tiled.tilemapLoader = require("lib.tilemap.tilemapLoader"):new()

	return newInstance
end



return tiled
