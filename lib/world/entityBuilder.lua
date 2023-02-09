local EntityBuilder = {}

function EntityBuilder:New(name)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.Name = name or "NewEntity"
	return newInstance
end

function EntityBuilder:MakeGridMovable()
	self.IGridMovable = {
		GridX = 0,
		GridY = 0
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

return EntityBuilder