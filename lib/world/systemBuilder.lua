local systemBuilder = {}

function systemBuilder.getDrawSystem()
	local system = Ecs.processingSystem()
	system.name = "Draw"
	system.drawSystem = true
	system.filter = Ecs.requireAll("IDrawable")

	function system:process(entity, dt)
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.rectangle("fill", entity.IDrawable.worldX, entity.IDrawable.worldY, 32, 32)
		love.graphics.setColor(1, 1, 1, 1)
	end

	return system
end

function systemBuilder.getMoveSystem()
	local system = Ecs.processingSystem()
	system.name = "Move"
	system.updateSystem = true
	system.filter = Ecs.requireAll("IGridMovable", "IControllable", "ISimulated")

	function system:onAdd(entity)
		if entity.IDrawable then
			entity.IDrawable.worldX = entity.IGridMovable.gridX * self.worldManager.tileWidth
			entity.IDrawable.worldY = entity.IGridMovable.gridY  * self.worldManager.tileHeight
		end
	end

	function system:_changeMap(tile)
		Observer:trigger(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, {"Teleporting to: " .. tile.map})
		CurrentScene:_changeMap(tile.map)
	end

	function system:_moveEntity(entity, gridX, gridY)
		local tile = self.worldManager:getTile(gridX, gridY)
		if tile then

			if tile.type == "portal" then
				return "portal", tile
			end

			if tile.type ~= "wall" then
				entity.IGridMovable.gridX = gridX
				entity.IGridMovable.gridY = gridY
				return "moved" , tile
			end
		end
		return nil, nil
	end

	function system:process(entity, dt)
		if (entity.ISimulated.onTurn == true and entity.IControllable.possesed == true) then
			local action = nil
			local tile = nil

			if (Input:isActionPressed("RIGHT")) then
				local newGridX = entity.IGridMovable.gridX + 1
				action, tile = self:_moveEntity(entity, newGridX, entity.IGridMovable.gridY)
			end

			if (Input:isActionPressed("LEFT")) then
				local newGridX = entity.IGridMovable.gridX - 1
				action, tile = self:_moveEntity(entity, newGridX, entity.IGridMovable.gridY)
			end

			if (Input:isActionPressed("UP")) then
				local newGridY = entity.IGridMovable.gridY - 1
				action, tile = self:_moveEntity(entity, entity.IGridMovable.gridX, newGridY)
			end

			if (Input:isActionPressed("DOWN")) then
				local newGridY = entity.IGridMovable.gridY + 1
				action, tile = self:_moveEntity(entity, entity.IGridMovable.gridX, newGridY)
			end

			if action then
				if action == "moved" then
					Observer:trigger(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, { "You moved." })
					--TODO: uncomment
					entity.ISimulated.onTurn = false

					if entity.IDrawable then
						entity.IDrawable.worldX = entity.IGridMovable.gridX * self.worldManager.tileWidth
						entity.IDrawable.worldY = entity.IGridMovable.gridY * self.worldManager.tileHeight
					end

					self.worldManager:nextRound()
				elseif action == "portal" then
					self:_changeMap(tile)
				end
			end
		end
	end

	return system
end

function systemBuilder.getRoundSystem()
	local system = Ecs.sortedProcessingSystem()
	system.name = "Round"
	system.roundSystem = true
	system.filter = Ecs.requireAll("ISimulated", "Stats")

	function system:compare(entity1, entity2)
		return entity1.Stats.defaultActionPoints > entity2.Stats.defaultActionPoints
	end

	function system:process(entity, dt)
		if entity.ISimulated.onTurn == false then
			entity.ISimulated.onTurn = true
		end

		Debug:log("Simulating" .. entity.name)
		-- TODO: Simulate AI?		
	end

	return system
end

return systemBuilder
