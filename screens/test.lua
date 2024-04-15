local screen = {}

function screen.load(last)
    love.graphics.setBackgroundColor(0.2,0.2,0.2)

    World = Bf.newWorld(0,80,true)

    Ground = Bf.Collider.new(World,"rect",128,224,256,32)
    Ground:setType("static")

    Ball = Bf.Collider.new(World,"rect",128,120,20,20)
    Ball:setMass(5)
    Ball:setRestitution(0.2)
    Ball:setFriction(0.9)

    Block = Bf.Collider.new(World,"rect",192,120,20,20)
    Block:setMass(5)
    Block:setRestitution(0.2)
    Block:setFriction(0.9)

    function Block:enter(other, collision)
        local nx, ny = collision:getNormal()
        local sx, sy = self:getPosition()
        local ox, oy = other:getPosition()
        if (oy < sy) and ny < -0.75 then
            self:destroy()
        end
    end
end
function screen.update(dt)
    World:update(dt)
    if love.keyboard.isDown("right") then
        Ball:applyForce(400, 0)
    elseif love.keyboard.isDown("left") then
        Ball:applyForce(-400, 0)
    elseif love.keyboard.isDown("up") then
        Ball:setPosition(128,120)
        Ball:setLinearVelocity(0, 0)
    elseif love.keyboard.isDown("down") then
        Ball:applyForce(0, 600)
    end
end
function screen.draw()
    love.graphics.setColor(1, 1, 1)
    World:draw()
end

function screen.mousepressed(x, y, b)
end
function screen.mousereleased(x, y, b)
end

return screen