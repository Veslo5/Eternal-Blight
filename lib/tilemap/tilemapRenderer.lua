local TileMapRenderer = {}

TileMapRenderer.TilemapLoader = require("lib.tilemap.tilemapLoader")
TileMapRenderer.AtlasFactory = require("lib.sprites.atlas")

TileMapRenderer.TileSetAtlas = nil
TileMapRenderer.SpriteBatches = {}



function TileMapRenderer:LoadResources()
    self.TilemapLoader:LoadTileset("data/test_map001.lua")
    self.TileSetAtlas = self.AtlasFactory:New(self.TilemapLoader.TilesetMetadata.image, 32, 32, true)
    self.TileSetAtlas:CutQuads()
    self:BakeLayers()

    -- self.TileSetAtlas:BeginBatch()

    -- local layer = self.TilemapLoader.TileMapMetadata.layers[1]

    -- -- aand -1 for indexes again
    -- local layerHeight = layer.height
    -- local width = layer.width - 1
    -- local height = layer.height - 1

    -- for column = 0, width, 1 do
    --     for row = 0, height, 1 do
    --         -- + 1 coz indexes
    --         local index = ((row * layerHeight) + column) + 1
    --         local tileNumber = layer.data[index]
    --         self.TileSetAtlas:RedrawBatchQuads(tileNumber, column * 32, row * 32)

    --     end
    -- end

    -- self.TileSetAtlas:EndBatch()

end

function TileMapRenderer:BakeLayers()
    for _, layer in ipairs(self.TilemapLoader.TileMapMetadata.layers) do
        if (layer.type == "group") then                  
            local currentBatch = love.graphics.newSpriteBatch(self.TileSetAtlas.Texture, (self.TileSetAtlas.Columns - 1) * (self.TileSetAtlas.Rows - 1))

            currentBatch:clear()

            table.insert(self.SpriteBatches, currentBatch)

            for __, layerInGroup in ipairs(layer.layers) do

                local layerHeight = layerInGroup.height
                local width = layerInGroup.width - 1
                local height = layerInGroup.height - 1

                for column = 0, width, 1 do
                    for row = 0, height, 1 do
                        -- + 1 coz indexes
                        local index = ((row * layerHeight) + column) + 1                                      
                        local tileNumber = layerInGroup.data[index] 

                        if(tileNumber ~= 0) then                            
                            --print(layer.name, layerInGroup.name, tileNumber, column * 32, row * 32)
                            currentBatch:add(self.TileSetAtlas.Quads[tileNumber], column * 32, row * 32 )
                        end
                    end
                end                   
            end

            currentBatch:flush()
        end
    end    
end

function TileMapRenderer.UnloadResources()

end

function TileMapRenderer:Draw()
    -- local layer = self.TilemapLoader.TileMapMetadata.layers[1]

    -- -- aand -1 for indexes again
    -- local layerHeight = layer.height
    -- local width = layer.width - 1
    -- local height = layer.height - 1

    -- for column = 0, width, 1 do
    --     for row = 0, height, 1 do
    --         -- + 1 coz indexes
    --         local index = ((row * layerHeight) + column) + 1

    --         local tileNumber = layer.data[index]
    --         self.TileSetAtlas:DrawQuad(tileNumber, column * 32, row * 32)
    --     end
    -- end
    -- self.TileSetAtlas:DrawBatch(0,0)

    for _, batch in ipairs(self.SpriteBatches) do
        love.graphics.draw(batch,0,0)
    end
    

end

return TileMapRenderer
