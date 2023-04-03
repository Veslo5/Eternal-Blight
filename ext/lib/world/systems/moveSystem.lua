local moveSystem = {}

function moveSystem.getSystem()
	local system = Ecs.processingSystem()
	system.name = "Move"
	system.updateSystem = true
	system.filter = Ecs.requireAll("IGridMovable", "IControllable", "ISimulated")

	function system:onAdd(entity)
		if entity.IDrawable then
			entity.IDrawable.worldX = entity.IGridMovable.gridX * self.worldManager.grid.tileWidth
			entity.IDrawable.worldY = entity.IGridMovable.gridY * self.worldManager.grid.tileHeight

			self.worldManager:updateFog(10, entity.IGridMovable.gridX, entity.IGridMovable.gridY)
		end
	end

	function system:_changeMap(tile)
		Observer:trigger(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, { "Teleporting to: " .. tile.map })
		self.worldManager:changeMap(tile.map)
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
				return "moved", tile
			end
		end
		return nil, nil
	end

	function system:_checkMovement(entity)
		if (Input:isActionPressed("RIGHT")) then
			local newGridX = entity.IGridMovable.gridX + 1
			return self:_moveEntity(entity, newGridX, entity.IGridMovable.gridY)
		end

		if (Input:isActionPressed("LEFT")) then
			local newGridX = entity.IGridMovable.gridX - 1
			return  self:_moveEntity(entity, newGridX, entity.IGridMovable.gridY)
		end

		if (Input:isActionPressed("UP")) then
			local newGridY = entity.IGridMovable.gridY - 1
			return self:_moveEntity(entity, entity.IGridMovable.gridX, newGridY)
		end

		if (Input:isActionPressed("DOWN")) then
			local newGridY = entity.IGridMovable.gridY + 1
			return self:_moveEntity(entity, entity.IGridMovable.gridX, newGridY)
		end
	end

	function system:process(entity, dt)
		if (entity.ISimulated.onTurn == true and entity.IControllable.possesed == true) then
			local action = nil
			local tile = nil

			action, tile = self:_checkMovement(entity)

			if action then
				if action == "moved" then
					Observer:trigger(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, { "You moved." })
					--TODO: uncomment
					entity.ISimulated.onTurn = false

					if entity.IDrawable then
						entity.IDrawable.worldX = entity.IGridMovable.gridX * self.worldManager.grid.tileWidth
						entity.IDrawable.worldY = entity.IGridMovable.gridY * self.worldManager.grid.tileHeight
					end

					self.worldManager:updateFog(10, entity.IGridMovable.gridX, entity.IGridMovable.gridY)

					self.worldManager:nextRound()
				elseif action == "portal" then
					self:_changeMap(tile)
				end
			end
		end
	end

	return system
end

return moveSystem
