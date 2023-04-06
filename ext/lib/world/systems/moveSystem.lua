local moveSystem = {}

function moveSystem.getSystem()
	local system = Ecs.processingSystem()
	system.name = "Move"
	system.updateSystem = true
	system.filter = Ecs.requireAll("IGridMovable", "IControllable", "ISimulated")

	function system:onAdd(entity)
		if entity.IDrawable then
			entity.IDrawable.worldX = entity.tile.x * self.worldManager.grid.tileWidth
			entity.IDrawable.worldY = entity.tile.y * self.worldManager.grid.tileHeight

			self.worldManager:updateFog(10, entity.tile.x, entity.tile.y)
		end
	end

	function system:_changeMap(entity)
		Observer:trigger(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, { "Teleporting to: " .. entity.Portal.map })
		self.worldManager:changeMap(entity.Portal.map)
	end

	function system:_moveEntity(entity, gridX, gridY)
		local tile = self.worldManager:getTile(gridX, gridY)
		if tile then
			-- nothing happens when tile is occupied or is wall
			if tile.wall == true then
				return nil, nil
			end

			-- for now using first object
			local tileObject = tile.objects[1]
			if tileObject then
				if tileObject.type == "portal" then
					return "portal", tileObject
				end
			end

			-- movement: refreshing references entity -> tile and tile -> entity
			local indexToRemove = nil
			for index, tileEntity in ipairs(entity.tile.objects) do
				if tileEntity == entity then
					indexToRemove = index
					break
				end
			end

			table.remove(entity.tile.objects, indexToRemove)

			entity.tile = tile
			table.insert(tile.objects, entity)

			return "moved", nil
		end
		return nil, nil
	end

	function system:_checkMovement(entity)
		if (Input:isActionPressed("RIGHT")) then
			local newGridX = entity.tile.x + 1
			return self:_moveEntity(entity, newGridX, entity.tile.y)
		end

		if (Input:isActionPressed("LEFT")) then
			local newGridX = entity.tile.x - 1
			return self:_moveEntity(entity, newGridX, entity.tile.y)
		end

		if (Input:isActionPressed("UP")) then
			local newGridY = entity.tile.y - 1
			return self:_moveEntity(entity, entity.tile.x, newGridY)
		end

		if (Input:isActionPressed("DOWN")) then
			local newGridY = entity.tile.y + 1
			return self:_moveEntity(entity, entity.tile.x, newGridY)
		end
	end

	function system:process(entity, dt)
		if (entity.ISimulated.onTurn == true and entity.IControllable.possesed == true and entity.IGridMovable.enabled == true) then
			local action = nil
			local object = nil

			action, object = self:_checkMovement(entity)

			if action then
				if action == "moved" then
					Observer:trigger(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, { "You moved." })
					
					entity.ISimulated.onTurn = false

					if entity.IDrawable then
						entity.IDrawable.worldX = entity.tile.x * self.worldManager.grid.tileWidth
						entity.IDrawable.worldY = entity.tile.y * self.worldManager.grid.tileHeight
					end

					self.worldManager:updateFog(10, entity.tile.x, entity.tile.y)

					self.worldManager:nextRound()
				elseif action == "portal" then
					self:_changeMap(object)
				end
			end
		end
	end

	return system
end

return moveSystem
