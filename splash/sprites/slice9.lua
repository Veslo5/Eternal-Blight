local slice = {}

function slice:New(texture, leftPadding, rightPadding, topPadding, bottomPadding)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.texture = texture
	newInstance.padding = {
		leftPadding = leftPadding,
		rightPadding = rightPadding,
		topPadding = topPadding,
		bottomPadding = bottomPadding
	}
	newInstance.sourceQuads = newInstance:_sliceQ()
	newInstance.destination = newInstance:_sliceR(0,0,200,200)

	return newInstance
end

function slice:setDestination(x, y, w, h)
	self.destination = self:_sliceR(x,y,w,h)
end

function slice:_sliceQ(x, y, w, h)
	local x = x or 0
	local y = y or 0
	local w = w or self.texture:getWidth()
	local h = h or self.texture:getHeight()
	local middleWidth = w - self.padding.leftPadding - self.padding.rightPadding
	local middleHeight = h - self.padding.topPadding - self.padding.bottomPadding
	local bottomY = y + h - self.padding.bottomPadding
	local rightX = x + w - self.padding.rightPadding
	local leftX = x + self.padding.leftPadding
	local topY = y + self.padding.topPadding

	local quadTable = {}
	table.insert(quadTable, love.graphics.newQuad(x, y, self.padding.leftPadding, self.padding.topPadding, self.texture))
	table.insert(quadTable, love.graphics.newQuad(leftX, y, middleWidth, self.padding.topPadding, self.texture))
	table.insert(quadTable,	love.graphics.newQuad(rightX, y, self.padding.rightPadding, self.padding.topPadding, self.texture))
	table.insert(quadTable, love.graphics.newQuad(x, topY, self.padding.leftPadding, middleHeight, self.texture))
	table.insert(quadTable, love.graphics.newQuad(leftX, topY, middleWidth, middleHeight, self.texture))
	table.insert(quadTable, love.graphics.newQuad(rightX, topY, self.padding.rightPadding, middleHeight, self.texture))
	table.insert(quadTable,	love.graphics.newQuad(x, bottomY, self.padding.leftPadding, self.padding.bottomPadding, self.texture))
	table.insert(quadTable, love.graphics.newQuad(leftX, bottomY, middleWidth, self.padding.bottomPadding, self.texture))
	table.insert(quadTable,	love.graphics.newQuad(rightX, bottomY, self.padding.rightPadding, self.padding.bottomPadding, self.texture))

	return quadTable
end

function slice:_sliceR(x, y, w, h)
	local x = x or 0
	local y = y or 0
	local w = w or self.texture:getWidth()
	local h = h or self.texture:getHeight()
	local middleWidth = w - self.padding.leftPadding - self.padding.rightPadding
	local middleHeight = h - self.padding.topPadding - self.padding.bottomPadding
	local bottomY = y + h - self.padding.bottomPadding
	local rightX = x + w - self.padding.rightPadding
	local leftX = x + self.padding.leftPadding
	local topY = y + self.padding.topPadding

	local quadTable = {}
	table.insert(quadTable, { x = x, y = y, w = self.padding.leftPadding, h = self.padding.topPadding })
	table.insert(quadTable, { x = leftX, y = y, w = middleWidth, h = self.padding.topPadding })
	table.insert(quadTable, { x = rightX, y = y, w = self.padding.rightPadding, h = self.padding.topPadding })
	table.insert(quadTable, { x = x, y = topY, w = self.padding.leftPadding, h = middleHeight })
	table.insert(quadTable, { x = leftX, y = topY, w = middleWidth, h = middleHeight })
	table.insert(quadTable, { x = rightX, y = topY, w = self.padding.rightPadding, h = middleHeight })
	table.insert(quadTable, { x = x, y = bottomY, w = self.padding.leftPadding, h = self.padding.bottomPadding })
	table.insert(quadTable, { x = leftX, y = bottomY, w = middleWidth, h = self.padding.bottomPadding })
	table.insert(quadTable, { x = rightX, y = bottomY, w = self.padding.rightPadding, h = self.padding.bottomPadding })

	for _, value in ipairs(quadTable) do
		value.w = value.x + value.w
		value.h = value.y + value.h
	end

	return quadTable
end

function slice:draw()		
	-- for i = 1, #self.sourceQuads, 1 do
	-- 	local destination = self.destination[i]
	-- 	local sw, sh = self.sourceQuads[i]:getTextureDimensions()
	-- 	-- print( destination.w / sw)
	-- 	-- print(destination.h / sh)

	-- 	love.graphics.draw(self.texture, self.sourceQuads[i], destination.x, destination.y, 0, destination.w / sw,  destination.h / sh)
	-- end
end

return slice
