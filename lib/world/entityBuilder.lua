local EntityBuilder = {}
EntityBuilder.entityFactory = require("lib.world.entity")

function EntityBuilder:NewEntity(name)
	return self.entityFactory:New(name)
end

function EntityBuilder.MakeMovable(entity)
	if not entity.Movement then
		entity.Movement = {
			GridX = 0,
			GridY = 0
		}
	end

	return entity
end

function EntityBuilder.MakeDrawable(entity, image)
	if not entity.Drawing then
		entity.Drawing = {
			X = 0,
			Y = 0,
			Texture = image or nil
		}
	end

	return entity
end

return EntityBuilder