local UIManager = {}

UIManager.ContainerHolder = {}

function UIManager:Load()
local consolaFactory = require("lib.ui.uiConsola")
local consola = consolaFactory:New(0,0, 500, 250)
consola:AddText("Trying some texts here")
consola:AddText("Hehe some longer ones...................................")
consola:AddText("Third one!")
consola:AddText("༼ つ ◕_◕ ༽つ (‿|‿) (‿|‿) (‿|‿) (‿|‿)")

table.insert(self.ContainerHolder, consola)
end


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