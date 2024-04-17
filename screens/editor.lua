local screen = {}

function screen.load(last)
    love.graphics.setBackgroundColor(0.2,0.2,0.2)
end
function screen.update(dt)
end
function screen.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.push()
    love.graphics.translate(-ScrollX,0)
    love.graphics.pop()
end

function screen.mousepressed(x,y,b)
end
function screen.mousereleased(x,y,b)
end

return screen