local entityBuilder = {}

function entityBuilder:new(name, type, gridTile)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.name = name or "newentity"
	newInstance.type = type or "undefined"	
	newInstance.tile = gridTile or nil

	return newInstance
end

function entityBuilder:makeSpawn(id)
	self.Spawn = {
		id = id
	}
end

function entityBuilder:makePortal(map)
	self.Portal = {
		map = map
	}
end

function entityBuilder:makeGridMovable(movable)
	self.IGridMovable = {
		enabled = movable or false
	}

	return self
end

function entityBuilder:makeDrawable(image, color, state, states, offsetX, offsetY, zIndex )
	self.IDrawable = {
		worldX = 0,
		worldY = 0,
		offsetX = offsetX or 0,
		offsetY = offsetY or 0,
		image = image or nil,
		color =  color or {1,1,1,1},
		currentState = state or 1,
		states = states or nil,
		zIndex = zIndex or 1,
		animation = require("splash.sprites.animation"):new(nil, nil, nil, nil, nil, nil, nil ,nil , true)
	}

	return self
end

function entityBuilder:addInventory(maxWeight)
	self.Inventory = {
		items = {},
		maxWeight = maxWeight or 0
	}
	return self
end

function entityBuilder:addStats(ap, hp, mp)
	self.Stats = {
		defaultActionPoints = ap,
		currentActionPoints = ap,
		defaultHealthPoints = hp,
		currentHealthPoints = hp,
		defaultManaPoints = mp,
		currentManaPoints = mp
	}

	return self
end

function entityBuilder:makeControllable(possesed)
	self.IControllable = {
		possesed = possesed or false,
	}

	return self
end

function entityBuilder:makeSimulated(onTurn)
self.ISimulated = {
	onTurn = onTurn or false
}

	return self
end

return entityBuilder	