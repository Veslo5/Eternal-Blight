local EntityBuilder = {}

function EntityBuilder:New(name)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.Name = name or "NewEntity"
	return newInstance
end

function EntityBuilder:MakeGridMovable(x,y)
	self.IGridMovable = {
		GridX = x or 0,
		GridY = y or 0
	}

	return self
end

function EntityBuilder:MakeDrawable()
	self.IDrawable = {
		WorldX = 0,
		WorldY = 0,
		Image = nil
	}

	return self
end

function EntityBuilder:AddStats(ap, hp, mp)
	self.Stats = {
		DefaultActionPoints = ap,
		CurrentActionPoints = ap,
		DefaultHealthPoints = hp,
		CurrentHealthPoints = hp,
		DefaultManaPoints = mp,
		CurrentManaPoints = mp
	}

	return self
end

function EntityBuilder:MakeControllable(possesed, onTurn)
	self.IControllable = {
		Possesed = possesed or false,
		OnTurn = onTurn or false
	}

	return self
end

function EntityBuilder:MakeSimulated()
	self.ISimulated = true

	return self
end

return EntityBuilder	