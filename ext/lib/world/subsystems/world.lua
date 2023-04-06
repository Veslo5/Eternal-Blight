local world = {}
world.mapWorld = Ecs.world()

world.entityBuilder = require("ext.lib.world.entityBuilder")
world.systemBuilder = require("ext.lib.world.systemBuilder")


world.worldObjects = {}

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
end

function world:addEntity(entity)
	Ecs.add(self.mapWorld, entity)
end

function world:addPlayer()
	local playerEntity = self.entityBuilder:new("Player")

	local spawnTile = self:getObjectOfType("spawn")
	if spawnTile then
		playerEntity:makeGridMovable(spawnTile.tile.x - 1, spawnTile.tile.y - 1)
	else
		--TODO: not like this. Every map should have spawn
		playerEntity:makeGridMovable(1, 1)
	end

	playerEntity:makeControllable(true)
	playerEntity:makeDrawable(nil, { 0, 1, 0, 1 })
	playerEntity:makeSimulated(true)
	playerEntity:addStats(1, 10, 10)

	MainCamera:follow(playerEntity.IDrawable, "worldX", "worldY")

	self:addEntity(playerEntity)
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

function world:getObjectOfType(type)
	for _, object in pairs(self.worldObjects) do
		if object.type == type then
			return object
		end
	end
	return nil
end

function world:getObjectsOfType(type)
	local objects = {}
	for _, object in pairs(self.worldObjects) do
		if object.type == type then
			table.insert(objects, object)
		end
	end
	return objects
end

function world:setupObjects(worldObjects, grid)
	for _, object in ipairs(worldObjects.objects) do
		-- tileset object alignment must be set to top left!
		local tileX, tileY = grid:getTileGridPosition(object.x, object.y)
		local tile = grid:getTile(tileX, tileY)

		if object.properties["type"] == "port" then
			if tile ~= nil then
				local dataObject = {
					type = "portal",
					map = object.properties["map"],
					tile = tile
				}
				tile.type = "portal"
				tile.map = object.properties["map"]
				table.insert(self.worldObjects, dataObject)
			end
		elseif object.properties["type"] == "spawn" then
			if tile ~= nil then
				local dataObject = {
					type = "spawn",
					tile = tile
				}
				tile.type = "spawn"
				table.insert(self.worldObjects, dataObject)
			end
		elseif object.properties["type"] == "stash" then
			if tile ~= nil then
				local dataObject = {
					type = "stash",
					tile = tile,
					items = object.properties["items"]
				}
				tile.type = "item"
				table.insert(self.worldObjects,dataObject)
			end
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

	self.worldObjects = {}
	Debug:log("[CORE] Unloaded grid objects")
end

return world
