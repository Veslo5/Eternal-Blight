local Atlas = {}

Atlas.Texture = nil
Atlas.Quads = {}
Atlas.QuadWidth = 0
Atlas.QuadHeight = 0
Atlas.TextureWidth = 0
Atlas.TextureHeight = 0
Atlas.QuadsCount = 0

Atlas.Columns = 0
Atlas.Rows = 0

Atlas.UseBatch = false
Atlas.SpriteBatch = nil

function Atlas:New(path, quadWidth, quadHeight, useBatch)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.useBatch = useBatch

    newInstance.Texture = love.graphics.newImage(path)
    newInstance.Texture:setFilter("nearest", "linear")
    newInstance.TextureWidth = newInstance.Texture:getWidth()
    newInstance.TextureHeight = newInstance.Texture:getHeight()

    newInstance.QuadWidth = quadWidth
    newInstance.QuadHeight = quadHeight

    newInstance.Columns = newInstance.TextureWidth / newInstance.QuadWidth
    newInstance.Rows = newInstance.TextureHeight / newInstance.QuadHeight



    -- if newInstance.useBatch then
    --     newInstance.SpriteBatch = love.graphics.newSpriteBatch(newInstance.Texture, (newInstance.Columns - 1) * (newInstance.Rows - 1))
    -- end

    return newInstance
end

-- function Atlas:BeginBatch()
-- assert(self.UseBatch, "Batching is not allowed for this atlas!")
--     self.SpriteBatch:clear()
-- end

-- function Atlas:RedrawBatchQuads(index, x, y)
--     self.SpriteBatch:add(self.Quads[index], x, y)
-- end

-- function Atlas:EndBatch()
--     self.SpriteBatch:flush()
-- end

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

-- function Atlas:DrawQuad(index, x, y)
--     love.graphics.draw(self.Texture, self.Quads[index], x, y)
-- end

-- function Atlas:DrawBatch(x, y)
--     love.graphics.draw(self.SpriteBatch, x, y)
-- end

return Atlas
