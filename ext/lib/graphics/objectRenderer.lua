local objectRenderer = {}

objectRenderer.atlasFactory = require("splash.sprites.atlas")

objectRenderer.atlases = {}
objectRenderer.animations = {}

function objectRenderer:addAtlas(name, resource)
	if objectRenderer.atlases[name] then
		local atlas = self.atlasFactory:new(resource, CONST_SPRITE_SIZEX, CONST_SPRITE_SIZEY)
		atlas:cutQuads()
		objectRenderer.atlases[name] = atlas
	end
end

function objectRenderer:drawAtlasQuad(name, index, x, y)
	local atlas = objectRenderer.atlases[name]
	love.graphics.draw(atlas.texture,  atlas.quads[index], x, y)
end

function  objectRenderer:unload()
	for _, atlas in pairs(self.atlases) do
		atlas:unload()
	end
	self.atlases = {}
	Debug:log("Unloaded object renderer atlases")
	self.animations = {}

end

return objectRenderer