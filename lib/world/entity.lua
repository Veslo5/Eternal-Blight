local Entity = {}

Entity.Extensions = {}

function Entity:New()
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	return newInstance
end

return Entity