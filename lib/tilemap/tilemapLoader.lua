local TileMapLoader = {}

TileMapLoader.TileMapMetadata = nil
TileMapLoader.TilesetMetadata = nil


function TileMapLoader:LoadTileset(name)
    -- TODO: Check for errors with Pcall
    local chunk = love.filesystem.load(name)    
    local tileMapMetadata = chunk()

    local tilesetFileName = tileMapMetadata.tilesets[1].exportfilename

    chunk = love.filesystem.load("data/" .. tilesetFileName)
    local tilesetMetadata = chunk()

    self.TileMapMetadata = tileMapMetadata
    self.TilesetMetadata = tilesetMetadata


end

function TileMapLoader:GetGroupLayer(name)
    for _, layer in ipairs(self.TileMapMetadata.layers) do
        if (layer.type == "group") then
            if (layer.name == name) then
                return layer
            end
        end
    end
    return nil
end

function TileMapLoader:UnloadTileset()
    self.TileMapMetadata = nil
    self.TilesetMetadata = nil
end


return TileMapLoader