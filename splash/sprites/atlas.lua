local atlas = {}

function atlas:new(resource, quadWidth, quadHeight, useBatch)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.useBatch = useBatch

	newInstance.texture = resource
	newInstance.texture:setFilter("nearest", "nearest")
	newInstance.textureWidth = newInstance.texture:getWidth()
	newInstance.textureHeight = newInstance.texture:getHeight()

	newInstance.quads = {}
	newInstance.quadsCount = 0
	newInstance.quadWidth = quadWidth
	newInstance.quadHeight = quadHeight

	newInstance.columns = newInstance.textureWidth / newInstance.quadWidth
	newInstance.rows = newInstance.textureHeight / newInstance.quadHeight



	return newInstance
end

function atlas:cutQuads()
	-- -1 because lua arrays starting from 1 and we are using starting index as 0
	local columns = self.columns - 1
	local rows = self.rows - 1

	for x = 0, rows, 1 do
		for y = 0, columns, 1 do

			local quadX = y * self.quadWidth
			local quadY = x * self.quadHeight
			local quad = love.graphics.newQuad(quadX, quadY, self.quadWidth, self.quadHeight, self.textureWidth,
				self.textureHeight)
			table.insert(self.quads, quad)

			self.quadsCount = self.quadsCount + 1
		end
	end
end

function atlas:getAtlasQuadCount()	
	return (self.columns - IIF(self.columns == 1, 0, 1)) * (self.rows - IIF(self.rows == 1, 0, 1))
end

function atlas:unload()
	self.quads = nil
	self.texture = nil	
end

return atlas
