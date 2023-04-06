local world = {}
world.mapWorld = Ecs.world()

world.entityBuilder = require("ext.lib.world.entityBuilder")
world.systemBuilder = require("ext.lib.world.systemBuilder")
world.filesystem = require("ext.lib.filesystem.filesystem")

world.drawSystemFilter = nil
world.updateSystemFilter = nil
world.roundSystemFilter = nil

world.currentRound = 0

function world:ecsInit(worldManager)
	self:addSystem(self.systemBuilder.getMoveSystem(), worldManager)
	self:addSystem(self.systemBuilder.getDrawSystem(), worldManager)
	self:addSystem(self.systemBuilder.getRoundSystem(), worldManager)

	-- Here we require all DrawSystem marked systems
	self.drawSystemFilter = Ecs.requireAll("drawSystem")
	self.updateSystemFilter = Ecs.requireAll("updateSystem")
	self.roundSystemFilter = Ecs.requireAll("roundSystem")

	Ecs.refresh(self.mapWorld)
end

--- Add entity into ECS world
---@param entity table
function world:addEntity(entity)
	Ecs.add(self.mapWorld, entity)
end

function world:addPlayer()
	local spawnTile = self:getEntityByName("start")
	local playerEntity = self.entityBuilder:new("Player", "character", spawnTile.tile)
	table.insert(spawnTile.tile.objects, playerEntity)
	playerEntity:makeGridMovable(true)
	playerEntity:makeControllable(true)
	playerEntity:makeDrawable("ext/resources/npc/idle_armor_casual.png", nil, nil, nil, -2, -12, 999)
	playerEntity:makeSimulated(true)
	playerEntity:addStats(1, 10, 10)
	
	MainCamera:follow(playerEntity.IDrawable, "worldX", "worldY")

	self:addEntity(playerEntity)
end

function world:addMob(name, tile, data)
	local mobEntity = self.entityBuilder:new(name, nil, tile)
	mobEntity:makeControllable(false)
	mobEntity:makeSimulated()
	-- TODO:
	--mobEntity:makeDrawable(image, nil, nil, imageStates)

end

function world:addStash(name, tile, image, imageStates)
	local stashEntity = self.entityBuilder:new(name, nil, tile)
	stashEntity:makeGridMovable(false)
	stashEntity:addInventory()
	stashEntity:makeDrawable(image, nil, nil, imageStates)

	self:addEntity(stashEntity)

	return stashEntity
end

function world:addSpawn(name, tile)
	local spawnEntity = self.entityBuilder:new(name, "spawn", tile)
	spawnEntity:makeGridMovable(false)
	spawnEntity:makeSpawn(0)

	self:addEntity(spawnEntity)
	return spawnEntity
end

function world:addPortal(name, map, tile)
	local portalEntity = self.entityBuilder:new(name, "portal", tile)
	portalEntity:makeGridMovable(false)
	portalEntity:makePortal(map)

	self:addEntity(portalEntity)
	return portalEntity
end

function world:addSystem(system, worldManager)
	system.worldManager = worldManager
	Ecs.addSystem(self.mapWorld, system)
	Debug:log("[GAMEPLAY] Added system: " .. system.name)
end

function world:nextRound()
	print("Starting next round")
	self.currentRound = self.currentRound + 1
	Ecs.update(self.mapWorld, love.timer.getDelta(), self.roundSystemFilter)
end

function world:setupObjects(worldObjects, grid)
	for _, object in ipairs(worldObjects.objects) do
		-- tileset object alignment must be set to top left!
		local tileX, tileY = grid:getTileGridPosition(object.x, object.y)
		local tile = grid:getTile(tileX ,tileY)

		if tile ~= nil then
			local objectType = object.properties["type"]
			if objectType == "portal" then

				local entity = self:addPortal(object.name, object.properties["map"], tile)
				table.insert(tile.objects, entity)

			elseif objectType == "spawn" then

				local entity = self:addSpawn(object.name, tile)
				table.insert(tile.objects, entity)

			elseif objectType == "stash" then				
				local item = self.filesystem:loadItem(object.properties["resource"])
				CurrentScene.loader:newImage(item.image, item.image, "objects")
				local entity = self:addStash(object.name, tile, item.image, item.imageStates)
				table.insert(tile.objects, entity)

			elseif objectType == "mob" then
				local mob = self.filesystem:loadItem(object.properties["resource"])
				CurrentScene.loader:newImage(mob.image, mob.image, "objects")
				
			end
		end
	end
end

function world:getEntitiesByType(type)
	local entities = {}
	for _, entity in ipairs(self.mapWorld.entities) do
		if entity.type == type then
			table.insert(entities, entity)
		end
	end
	return entities
end

function world:getEntityByName(name)
	return self:getEntity("name", name)
end

function world:getEntity(component, value)
	for _, entity in ipairs(self.mapWorld.entities) do
		if entity[component] == value then
			return entity
		end
	end
end

function world:update(dt)
	Ecs.update(self.mapWorld, dt, self.updateSystemFilter)
end

function world:draw()
	--print("Draw filter")
	Ecs.update(self.mapWorld, love.timer.getDelta(), self.drawSystemFilter)
end

function world:unload()
	Ecs.clearEntities(self.mapWorld)
	Ecs.clearSystems(self.mapWorld)
	Debug:log("[CORE] Unloaded ecs entities and systems")

end

return world
