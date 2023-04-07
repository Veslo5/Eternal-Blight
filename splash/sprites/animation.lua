local animation = {}

function animation:new(atlas, texture, frameWidth, frameHeight, frameTime, animationSpeed, startingFrame, endingFrame, paused)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	if atlas then
		newInstance.atlas = atlas
	else
		if texture then			
			newInstance.atlas = require("splash.sprites.atlas"):new(texture, frameWidth, frameHeight)
			newInstance.atlas:cutQuads()
		end
	end

	newInstance.animationProgress = 0
	newInstance.animationSpeed = animationSpeed or 1
	newInstance.animationTime = frameTime or 1
	newInstance.startingFrame = startingFrame or 1
	newInstance.endingFrame = endingFrame or 1
	newInstance.currentFrame = startingFrame or 1
	newInstance.pause = paused or false

	return newInstance
end

function animation:changeFrameRange(startingFrame, endingFrame)
	if startingFrame < 1 then
		error("starting frame cannot be less than zero")
	end

	if endingFrame > self.atlas.quadsCount then
		error("ending frame is larger than animation frames")
	end

	self.startingFrame = startingFrame
	self.endingFrame = endingFrame
	self:goToFrame(self.startingFrame)
end

function animation:continue()
	self.pause = false
end

function animation:pause()
	self.pause = true
end

function animation:goToFrame(frame)
	self.currentFrame = frame
	self.animationProgress = 0
end

function animation:update(dt)
	if self.pause == true then
		return
	end

	--Progressing with animation by speed
	self.animationProgress = self.animationProgress + dt * self.animationSpeed

	-- if we hit time to change animation
	if self.animationProgress >= self.animationTime then
		-- move animation to next frame
		self.currentFrame = self.currentFrame + 1

		--if current frame is on end
		if self.currentFrame >= self.endingFrame then
			-- set animation to start
			self.currentFrame = self.startingFrame
		end

		-- reset progres
		self.animationProgress = 0
	end
end

function animation:drawAtlas(atlas, x, y, r, sx, sy)
	love.graphics.draw(atlas.texture, atlas.quads[self.currentFrame], x, y, r, sx, sy)
end

function animation:draw(x, y, r, sx, sy)
	love.graphics.draw(self.atlas.texture, self.atlas.quads[self.currentFrame], x, y, r, sx, sy)
end

function animation:unload()
	self.atlas:unload()
	self.atlas = nil
end

return animation
