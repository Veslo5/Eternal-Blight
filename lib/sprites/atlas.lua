local Atlas = {}

Atlas.Texture = nil
Atlas.Quads = {}
Atlas.QuadWidth = 0
Atlas.QuadHeight = 0
Atlas.TextureWidth = 0
Atlas.TextureHeight = 0
Atlas.QuadsCount = 0

function Atlas:New(path, quadWidth, quadHeight)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.Texture = love.graphics.newImage(path)
    newInstance.TextureWidth = newInstance.Texture:getWidth()
    newInstance.TextureHeight = newInstance.Texture:getHeight()
    
    newInstance.QuadWidth = quadWidth
    newInstance.QuadHeight = quadHeight

    return newInstance
end

function Atlas:CutQuads()

    local columns = self.TextureWidth / self.QuadWidth
    local rows = self.TextureHeight / self.QuadHeight

    for x = 1, columns, 1 do
        for y = 1, rows, 1 do
            local quadX = (x - 1) * self.QuadWidth
            local quadY = (y - 1) * self.QuadHeight            

            table.insert(self.Quads, love.graphics.newQuad(quadX, quadY, self.QuadWidth, self.QuadHeight, self.TextureWidth, self.TextureHeight))
            self.QuadsCount = self.QuadsCount + 1
                    
        end
    end

end

function Atlas:DrawQuad(index, x, y)    
    love.graphics.draw(self.Texture, self.Quads[index], x, y)
end

return Atlas
