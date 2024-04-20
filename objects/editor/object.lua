EditorOBJ = Class("Editor.Object")

function EditorOBJ:initialize(idx,t,x,y,w,h,v,e)
    self.idx, self.t = idx, t
    self.x, self.y, self.w, self.h = (x-1)*16, (y-1)*16, w*16, h*16
    self.ox, self.oy, self.ow, self.oh = self.x, self.y, self.w, self.h
    self.v = v

    if e.draw then
        self.tdraw = Deepcopy(e.draw)
        self:batchCreate()
    end

    self.resizeMin = 1*16
    self.resizeMax = 16*16

    if e.resize then
        self.resize = Deepcopy(e.resize)
        self.margin = 4
    end
    self.savef = e.save

    self.moving = false
    self.resizing = false
end

function EditorOBJ:update(dt)
    local mx, my = (love.mouse.getX()/Env.scale)+ScrollX, love.mouse.getY()/Env.scale
    if self.moving then
        self.x, self.y = self:floor(mx-self.mx), self:floor(my-self.my)
    end
    if self.resizing then
        if TableContains(self.resizing, "top") then
            self.y = self:floor(my)
            self.h = self:ceil(self.oh-(my-self.oy))
            if self.h < self.resizeMin then
                self.h = self.resizeMin
                self.y = self:floor(self.oy+(self.oh-self.resizeMin))
            end
            if self.h > self.resizeMax then
                self.h = self.resizeMax
                self.y = self:floor(self.oy-(self.resizeMax-self.oh))
            end
        end
        if TableContains(self.resizing, "bottom") then
            self.h = self:ceil(my-self.y)
            if self.h < self.resizeMin then
                self.h = self.resizeMin
            end
            if self.h > self.resizeMax then
                self.h = self.resizeMax
            end
        end
        if TableContains(self.resizing, "left") then
            self.x = self:floor(mx)
            self.w = self:ceil(self.ow-(mx-self.ox))
            if self.w < self.resizeMin then
                self.w = self.resizeMin
                self.x = self:floor(self.ox+(self.ow-self.resizeMin))
            end
            if self.w > self.resizeMax then
                self.w = self.resizeMax
                self.x = self:floor(self.ox-(self.resizeMax-self.ow))
            end
        end
        if TableContains(self.resizing, "right") then
            self.w = self:ceil(mx-self.x)
            if self.w < self.resizeMin then
                self.w = self.resizeMin
            end
            if self.w > self.resizeMax then
                self.w = self.resizeMax
            end
        end
        self:batchCreate()
    end
end

function EditorOBJ:draw()
    --local x, y = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    if self.tdraw then
        love.graphics.draw(self.batch, self.x, self.y)
    end
    if self.moving or self.resizing then
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
        if self.resizing then
            love.graphics.setColor(1,1,1,0.4)
            if self.resize[1] then
                love.graphics.rectangle("fill", (self.x)+self.w-self.margin, self.y, self.margin, self.h)
                love.graphics.rectangle("fill", (self.x), self.y, self.margin, self.h)
            end
            if self.resize[2] then
                love.graphics.rectangle("fill", (self.x), self.y, self.w, self.margin)
                love.graphics.rectangle("fill", (self.x), self.y+self.h-self.margin, self.w, self.margin)
            end
            love.graphics.setColor(1,1,1)
        end
    end
end

--

function EditorOBJ:mousepressed(mx,my,b)
    local high = self:highlight(mx,my)
    if b ~= 1 or (not high) then return false end

    if high[1] == "body" then
        self.moving = true
        self.mx, self.my = self:floor((mx+ScrollX)-self.x), self:floor(my-self.y)
    end
    if high[1] == "edge" then
        self.resizing = high
        self.ox, self.oy, self.ow, self.oh = self.x, self.y, self.w, self.h
    end

    ScreenSelected = self
    return true
end

function EditorOBJ:mousereleased(mx,my,b)
    if b ~= 1 then return false end
    if self.moving then
        self.moving = false
        self:save()
    end
    if self.resizing then
        self.resizing = false
        self:save()
    end
end

function EditorOBJ:highlight(x,y)
    if self.resize then
        local left, top, right, bottom = false, false, false, false
        if self.resize[1] then
            right = AABB(x, y, 1/Env.scale, 1/Env.scale, self.x-ScrollX+self.w-self.margin, self.y, self.margin, self.h)
            left =  AABB(x, y, 1/Env.scale, 1/Env.scale, self.x-ScrollX, self.y, self.margin, self.h)
        end
        if self.resize[2] then
            top =    AABB(x, y, 1/Env.scale, 1/Env.scale, self.x-ScrollX, self.y, self.w, self.margin)
            bottom = AABB(x, y, 1/Env.scale, 1/Env.scale, self.x-ScrollX, self.y+self.h-self.margin, self.w, self.margin)
        end
        if top or right or bottom or left then
            local result = {"edge"}
            if top    then table.insert(result, "top") end
            if bottom then table.insert(result, "bottom") end
            if left   then table.insert(result, "left") end
            if right  then table.insert(result, "right") end
            return result
        end
    end
    if AABB(x, y, 1/Env.scale, 1/Env.scale, self.x-ScrollX, self.y, self.w, self.h) then
        return {"body"}
    end
    return false
end

--

function EditorOBJ:batchCreate()
    local ox, oy = self.tdraw.ox or 0, self.tdraw.oy or 0
    self.batch = love.graphics.newSpriteBatch(self.tdraw.img,(self.w/16)*(self.h/16))
    for bx = 1, (self.w/16) do
        for by = 1, (self.h/16) do
            if type(self.tdraw.quad) == "function" then
                self:batchAdd(self.tdraw.quad(bx,by),(bx-1+ox)*16,(by-1+oy)*16)
            else
                self:batchAdd(self.tdraw.quad,(bx-1+ox)*16,(by-1+oy)*16)
            end
        end
    end
end

function EditorOBJ:batchAdd(q,x,y)
    if q then
        self.batch:add(q,x,y)
    else
        self.batch:add(x,y)
    end
end

function EditorOBJ:floor(val)
    return math.floor(val/16)*16
end
function EditorOBJ:ceil(val)
    return math.ceil(val/16)*16
end

function EditorOBJ:save()
    LEVEL[self.idx] = self.savef(self)
end