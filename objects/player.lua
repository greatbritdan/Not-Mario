PlayerOBJ = Class("Player")

function PlayerOBJ:initialize(x,y)
    self:setSize(1)
    self.x, self.y = (x-0.5)*16, (y-(self.h/32))*16

    self.collider = World:newCollider("rect",{self.x,self.y,self.w,self.h})
    self.collider:setFriction(0.8)

    self.grabbed = false
end

function PlayerOBJ:update(dt)
    self.x, self.y = self.collider:getPosition()
    self.r = self.collider:getAngle()

    if (not Env.settings.globalLaunch) and self.grabbed then
        self.grabbed = {x=self.x, y=self.y}
    end

    ScrollX = math.min(math.max(0, self.x-(self.w/2)-(Env.width/2)), 512-Env.width)
end

function PlayerOBJ:draw()
    local x, y = (love.mouse.getX()/Env.scale), (love.mouse.getY()/Env.scale)
    if self.grabbed then
        love.graphics.line(self.grabbed.x,self.grabbed.y,x+ScrollX,y)
    end

    love.graphics.draw(Marioimg,Marioquads[2+self.size],self.x,self.y,self.r,1,1,10,20)
    love.graphics.polygon("line", self.collider:getWorldPoints(self.collider:getPoints()))
end

function PlayerOBJ:mousepressed(x,y)
    if Env.settings.globalLaunch then
        self.grabbed = {x=x+ScrollX, y=y}
    elseif PointWithinCircle(x+ScrollX,y,self.x,self.y,self.grabRadius) then
        self.grabbed = {x=self.x, y=self.y}
    end
end

function PlayerOBJ:mousereleased(x,y)
    if self.grabbed then
        local dx, dy = self.grabbed.x-(x+ScrollX), self.grabbed.y-y
        if Env.settings.invertedMouse then
            dx, dy = -dx, -dy
        end

        self.collider:setLinearVelocity(dx*4,dy*4)
        self.collider:setAngularVelocity(dx/4)
        self.grabbed = false
    end
end

function PlayerOBJ:setSize(size)
    self.size = size
    if self.size == 1 then
        self.w, self.h = 12, 12
        self.grabRadius = 10
    else
        self.w, self.h = 12, 24
        self.grabRadius = 16
    end

    if self.collider then
        self.collider:destroy()
        self.collider = World:newCollider("rect",{self.x,self.y,self.w,self.h})
        self.collider:setFriction(0.8)
    end
end