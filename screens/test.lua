local screen = {}

require("objects.ground")
require("objects.player")

function screen.load(last)
    love.graphics.setBackgroundColor(0.2,0.2,0.2)

    World = Bf.newWorld(0,200,true)
    Ground = GroundOBJ:new(1,14,32,2)
    Player = PlayerOBJ:new(3,13)
end
function screen.update(dt)
    Player:update(dt)
    World:update(dt)
end
function screen.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.push()
    love.graphics.translate(-ScrollX,0)
    Ground:draw()
    Player:draw()
    love.graphics.pop()
end

function screen.mousepressed(x,y,b)
    Player:mousepressed(x,y)
end
function screen.mousereleased(x,y,b)
    Player:mousereleased(x,y)
end

function screen.keypressed(k)
    if k == "1" then
        Player:setSize(1)
    end
    if k == "2" then
        Player:setSize(2)
    end
end

return screen