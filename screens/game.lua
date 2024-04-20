local screen = {}

function screen.load(last)
    love.graphics.setBackgroundColor(0.4,0.5,0.9)
    LoadLevel()
end
function screen.update(dt)
    for i, v in pairs(OBJECTS["player"]) do
        v:update(dt)
    end
    World:update(dt)
end
function screen.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.push()
    love.graphics.translate(-ScrollX,0)

    for i, v in pairs(OBJECTS["ground"]) do
        v:draw()
    end
    for i, v in pairs(OBJECTS["player"]) do
        v:draw()
    end

    love.graphics.pop()
end

function screen.mousepressed(x,y,b)
    for i, v in pairs(OBJECTS["player"]) do
        v:mousepressed(x,y)
    end
end
function screen.mousereleased(x,y,b)
    for i, v in pairs(OBJECTS["player"]) do
        v:mousereleased(x,y)
    end
end

function screen.keypressed(k)
    if k == "f1" then
        Screen:changeState("editor", {"fade", 0.25, {0,0,0}}, {"fade", 0.25, {0,0,0}})
    end
end


return screen