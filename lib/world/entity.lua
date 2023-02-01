local Entity = {}

Entity.Extensions = {}

function Entity:New(name)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.Name = name
	
	return newInstance
end

return Entity