GroundOBJ = Class("Ground")

function GroundOBJ:initialize(x,y,w,h,q)
    self.x, self.y = ((x-1)+(w/2))*16, ((y-1)+(h/2))*16
    self.w, self.h = w*16, h*16

    self.batch = love.graphics.newSpriteBatch(Tilesimg, w*h)
    for bx = 1, w do
        for by = 1, h do
            self.batch:add(Tilequads[q],(bx-1)*16,(by-1)*16)
        end
    end

    self.collider = World:newCollider("rect",{self.x,self.y,self.w,self.h})
    self.collider:setType("static")
end

function GroundOBJ:draw()
    love.graphics.draw(self.batch,self.x-(self.w/2),self.y-(self.h/2))
    love.graphics.polygon("line", self.collider:getWorldPoints(self.collider:getPoints()))
end