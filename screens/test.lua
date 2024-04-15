local screen = {}

require("objects.ground")
require("objects.player")

function screen.load(last)
    love.graphics.setBackgroundColor(0.2,0.2,0.2)

    World = Bf.newWorld(0,80,true)
    Ground = GroundOBJ:new()
    Player = PlayerOBJ:new()
end
function screen.update(dt)
    World:update(dt)
end
function screen.draw()
    love.graphics.setColor(1,1,1)
    Ground:draw()
    Player:draw()
end

function screen.mousepressed(x,y,b)
    Player:mousepressed(x,y)
end
function screen.mousereleased(x,y,b)
    Player:mousereleased(x,y)
end

return screen