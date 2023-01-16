local TileMapLoader = {}

TileMapLoader.TileMapMetadata = nil
TileMapLoader.TilesetMetadata = nil


function TileMapLoader:LoadTileset(name)
    -- TODO: Check for errors with Pcall
    local chunk = love.filesystem.load("data/test_map001.lua")    
    local tileMapMetadata = chunk()

    local tilesetFileName = tileMapMetadata.tilesets[1].exportfilename

    chunk = love.filesystem.load("data/" .. tilesetFileName)
    local tilesetMetadata = chunk()

    self.TileMapMetadata = tileMapMetadata
    self.TilesetMetadata = tilesetMetadata


end



return TileMapLoader