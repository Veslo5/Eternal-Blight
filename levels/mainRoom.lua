local mainRoom = {}

mainRoom.input = require("lib.bindMe")
mainRoom.cameraFactory = require("lib.camera")
mainRoom.tilemapRenderer = require("lib.tilemap.tilemapRenderer")

function mainRoom.load()
    mainRoom.input:Bind("EXIT", "escape")

    mainRoom.input:Bind("UP", "w", "up")
    mainRoom.input:Bind("DOWN", "s", "down")
    mainRoom.input:Bind("LEFT", "a", "left")
    mainRoom.input:Bind("RIGHT", "d", "right")
    mainRoom.input:Bind("ZOOM", "q")
                
    GameplayCamera = mainRoom.cameraFactory:New()
    UiCamera = mainRoom.cameraFactory:New(100, "Fill", 1366, 768)

    mainRoom.tilemapRenderer:LoadResources()    

end

function mainRoom.update(dt)
    if (mainRoom.input:IsActionPressed("EXIT")) then
        love.event.quit()
    end

    if (mainRoom.input:IsActionDown("UP")) then
         GameplayCamera.VirtualY = GameplayCamera.VirtualY - dt * 500
    end

    if (mainRoom.input:IsActionDown("DOWN")) then
        GameplayCamera.VirtualY = GameplayCamera.VirtualY + dt * 500
    end

    if (mainRoom.input:IsActionDown("LEFT")) then
        GameplayCamera.VirtualX = GameplayCamera.VirtualX - dt * 500
    end

    if (mainRoom.input:IsActionDown("RIGHT")) then
        GameplayCamera.VirtualX = GameplayCamera.VirtualX + dt * 500
    end

    if (mainRoom.input:IsActionDown("ZOOM")) then
        GameplayCamera.Zoom = GameplayCamera.Zoom + dt 
    end
    
end

function mainRoom.draw()

    love.graphics.setBackgroundColor(0,0,0,1)
    
    GameplayCamera:BeginDraw()
    -- Gameplay rendering
    mainRoom.tilemapRenderer:Draw()
    GameplayCamera:EndDraw()
    local stats = love.graphics.getStats()
    
    UiCamera:BeginDraw()
    -- UI rendering    

    love.graphics.print(love.timer.getFPS(), 0, 0)
    love.graphics.print(stats.drawcalls, 0, 10)
    UiCamera:EndDraw()
end

--#####CALLBACKS######
function mainRoom.keypressed(key, scancode, isrepeat)
    mainRoom.input:KeyPressed(key, scancode, isrepeat)

end

function mainRoom.keyreleased(key, scancode)
    mainRoom.input:KeyRelease(key, scancode)

end

function mainRoom.mousepressed(x, y, button, istouch, presses)
    mainRoom.input:MousePressed(x, y, button, istouch, presses)

end

function mainRoom.mousereleased(x, y, button, istouch, presses)
    mainRoom.input:MouseReleased(x, y, button, istouch, presses)


end

function mainRoom.resize(width, height)

end

function mainRoom.unload()

end

return mainRoom