local entityBuilder = {}

function entityBuilder:new(name, worldManager)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.name = name or "NewEntity"
	newInstance.worldManager = worldManager
	return newInstance
end

function entityBuilder:makeGridMovable(x,y)
	self.IGridMovable = {
		gridX = x or 0,
		gridY = y or 0
	}

	return self
end

function entityBuilder:makeDrawable(image, color)
	self.IDrawable = {
		worldX = 0,
		worldY = 0,
		image = image or nil,
		color =  color or {1,1,1,1} 
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