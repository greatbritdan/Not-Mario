PlayerOBJ = Class("Player")

function PlayerOBJ:initialize()
    self.collider = Bf.Collider.new(World,"rect",128,120,12,12)

    self.grabbed = false
end

function PlayerOBJ:draw()
    --love.graphics.polygon("line", self.collider:getWorldPoints(self.collider:getPoints()))

    local x, y = self.collider:getPosition()
    local r = self.collider:getAngle()
    love.graphics.draw(Marioimg,x,y,r,1,1,10,10)

    if self.grabbed then
        local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
        love.graphics.line(mx,my,self.grabbed.x,self.grabbed.y)
    end
end

function PlayerOBJ:mousepressed(x,y)
    self.grabbed = {x=x, y=y}
end

function PlayerOBJ:mousereleased(x,y)
    if self.grabbed then
        local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
        local dx, dy = mx-self.grabbed.x, my-self.grabbed.y
        self.collider:applyLinearImpulse(dx, dy)
        self.collider:applyAngularImpulse(dx)
        self.grabbed = false
    end
end