local screen = {}

function screen.load(last)
    love.graphics.setBackgroundColor(0.2,0.2,0.2)
    LoadLevelEditor()

    ScreenSelected = false
end
function screen.update(dt)
    for i, v in pairs(OBJECTS) do
        v:update(dt)
    end
    if love.keyboard.isDown("d") then
        ScrollX = ScrollX + 128*dt
    end
    if love.keyboard.isDown("a") then
        ScrollX = ScrollX - 128*dt
    end
end
function screen.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.push()
    love.graphics.translate(-ScrollX,0)

    for i, v in pairs(OBJECTS) do
        v:draw()
    end

    love.graphics.pop()
end

function screen.mousepressed(x,y,b)
    if b == 2 then
        table.insert(LEVEL,{t="ground",x=math.ceil((x+ScrollX)/16),y=math.ceil(y/16),w=1,h=1,q=2})
        table.insert(OBJECTS,EditorOBJ:new(#LEVEL,"ground",math.ceil((x+ScrollX)/16),math.ceil(y/16),1,1,2,{
            draw = {img=Tilesimg, quad=Tilequads[2]},
            resize = {true,true},
            save = function (v)
                return {t="ground",x=v:ceil(v.x+1)/16,y=v:ceil(v.y+1)/16,w=v.w/16,h=v.h/16,q=v.v}
            end
        }))
    end
    if b == 3 then
        table.insert(LEVEL,{t="ground",x=math.ceil((x+ScrollX)/16),y=math.ceil(y/16),w=2,h=2,q=3})
        table.insert(OBJECTS,EditorOBJ:new(#LEVEL,"ground",math.ceil((x+ScrollX)/16),math.ceil(y/16),2,2,3,{
            draw = {img=Tilesimg, quad=function(x,y)
                if y == 1 then
                    return Tilequads[2+x]
                end
                return Tilequads[4+x]
            end},
            resize = {false,true},
            save = function (v)
                return {t="ground",x=v:ceil(v.x+1)/16,y=v:ceil(v.y+1)/16,w=v.w/16,h=v.h/16,q=3}
            end
        }))
    end

    local broke = false
    for i, v in pairs(OBJECTS) do
        if v:mousepressed(x,y,b) then
            broke = true
            break
        end
    end
    if (not broke) and ScreenSelected then
        ScreenSelected.selected = false
        ScreenSelected = false
    end
end
function screen.mousereleased(x,y,b)
    for i, v in pairs(OBJECTS) do
        if v:mousereleased(x,y,b) then
            break
        end
    end
end

function screen.keypressed(k)
    if k == "f1" then
        Screen:changeState("game", {"fade", 0.25, {0,0,0}}, {"fade", 0.25, {0,0,0}})
    end
end

return screen