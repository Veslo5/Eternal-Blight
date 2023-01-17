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

    -- -1 because lua arrays starting from 1 and we are using starting index as 0
    local columns = (self.TextureWidth / self.QuadWidth) - 1
    local rows = (self.TextureHeight / self.QuadHeight) - 1

    for x = 0, rows, 1 do
        for y = 0, columns, 1 do

            local quadX = y * self.QuadWidth 
            local quadY = x * self.QuadHeight
            
            table.insert(self.Quads, love.graphics.newQuad(quadX, quadY, self.QuadWidth, self.QuadHeight, self.TextureWidth, self.TextureHeight))
            self.QuadsCount = self.QuadsCount + 1            
        end
    end        
end

function Atlas:DrawQuad(index, x, y)    
    love.graphics.draw(self.Texture, self.Quads[index], x, y)
end

return Atlas
