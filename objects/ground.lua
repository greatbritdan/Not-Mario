GroundOBJ = Class("Ground")

function GroundOBJ:initialize()
    self.collider = Bf.Collider.new(World,"rect",128,224,256,32)
    self.collider:setType("static")
end

function GroundOBJ:draw()
    love.graphics.polygon("line", self.collider:getWorldPoints(self.collider:getPoints()))
end