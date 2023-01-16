local TileMapRenderer = {}

TileMapRenderer.TilemapLoader = require("lib.tilemap.tilemapLoader")
TileMapRenderer.AtlasFactory = require("lib.sprites.atlas")

TileMapRenderer.TileSetAtlas = nil


function TileMapRenderer:LoadResources()
    self.TilemapLoader:LoadTileset("")
    self.TileSetAtlas = self.AtlasFactory:New(self.TilemapLoader.TilesetMetadata.image, 32, 32)
    self.TileSetAtlas:CutQuads()

end

function TileMapRenderer.UnloadResources()

end

function TileMapRenderer:Draw()

    local layer = self.TilemapLoader.TileMapMetadata.layers[1]    
    for column = 1, 10, 1 do
        for row = 1, 10, 1 do
            --10 is height

            print((row * 10) + column)
            local tileNumber = layer.data[(row * 10) + column]            
            self.TileSetAtlas:DrawQuad(tileNumber, column * 32, row * 32)
        end
    end

end

return TileMapRenderer
