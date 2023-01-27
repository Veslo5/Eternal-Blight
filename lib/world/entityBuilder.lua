local EntityBuilder = {}
EntityBuilder.entityFactory = require("lib.world.entity")

function EntityBuilder:NewEntity ()
	return self.entityFactory:New()
end

function EntityBuilder.MakeMovable(entity)
	if not entity.Extensions["IMOVABLE"] then
		entity.Extensions["IMOVABLE"] = {
			GridX = 0,
			GridY = 0
		}
	end

	return entity
end


return EntityBuilder