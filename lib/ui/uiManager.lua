local UIManager = {}

UIManager.ContainerHolder = {}

function UIManager:Load()
local consolaFactory = require("lib.ui.uiConsola")
local consola = consolaFactory:New(0,0, 500, 250)
consola:AddText("First one")
consola:AddText("Second one...................................")
consola:AddText("Third one")
consola:AddText("Fourth one")

table.insert(self.ContainerHolder, consola)
end

--TODO: TEXT INPUT

function UIManager:Update(dt)
	for index, value in ipairs(self.ContainerHolder) do
		value:Update(dt)
	end	
end

function UIManager:Draw()
	for index, value in ipairs(self.ContainerHolder) do
		value:Draw()
	end
end

return UIManager