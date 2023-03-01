local Atlas = {}

function Atlas:New(resource, quadWidth, quadHeight, useBatch)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.useBatch = useBatch

	newInstance.Texture = resource
	newInstance.Texture:setFilter("nearest", "nearest")
	newInstance.TextureWidth = newInstance.Texture:getWidth()
	newInstance.TextureHeight = newInstance.Texture:getHeight()

	newInstance.Quads = {}
	newInstance.QuadsCount = 0
	newInstance.QuadWidth = quadWidth
	newInstance.QuadHeight = quadHeight

	newInstance.Columns = newInstance.TextureWidth / newInstance.QuadWidth
	newInstance.Rows = newInstance.TextureHeight / newInstance.QuadHeight



	return newInstance
end

function Atlas:CutQuads()
	-- -1 because lua arrays starting from 1 and we are using starting index as 0
	local columns = self.Columns - 1
	local rows = self.Rows - 1

	for x = 0, rows, 1 do
		for y = 0, columns, 1 do

			local quadX = y * self.QuadWidth
			local quadY = x * self.QuadHeight
			local quad = love.graphics.newQuad(quadX, quadY, self.QuadWidth, self.QuadHeight, self.TextureWidth,
				self.TextureHeight)
			table.insert(self.Quads, quad)

			self.QuadsCount = self.QuadsCount + 1
		end
	end
end

function Atlas:GetAtlasQuadCount()
	return (self.Columns - 1) * (self.Rows - 1)
end

function Atlas:Unload()
	self.Quads = nil
	self.Texture = nil	
end

return Atlas
