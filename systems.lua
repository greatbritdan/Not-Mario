function LoadLevel()
    local level = LEVEL

    ScrollX = 0

    OBJECTS = {}
    OBJECTS["player"] = {}
    OBJECTS["ground"] = {}

    World = Bf.newWorld(0,200,true)
    for i, v in pairs(level) do
        if v.t == "player" then
            table.insert(OBJECTS["player"],PlayerOBJ:new(v.x,v.y))
        end
        if v.t == "ground" then
            table.insert(OBJECTS["ground"],GroundOBJ:new(v.x,v.y,v.w,v.h,v.q))
        end
    end
end

function LoadLevelEditor()
    local level = LEVEL

    ScrollX = 0

    OBJECTS = {}

    for i, v in pairs(level) do
        if v.t == "player" then
            table.insert(OBJECTS,EditorOBJ:new(i,v.t,v.x,v.y,1,1,1,{
                draw = {img=Marioimg, quad=Marioquads[3], ox=-.125, oy=-.6875},
                save = function (v)
                    return {t="player",x=v:ceil(v.x+1)/16,y=v:ceil(v.y+1)/16}
                end
            }))
        end
        if v.t == "ground" then
            table.insert(OBJECTS,EditorOBJ:new(i,v.t,v.x,v.y,v.w,v.h,v.q,{
                draw = {img=Tilesimg, quad=Tilequads[v.q]},
                resize = {true,true},
                save = function (v)
                    return {t="ground",x=v:ceil(v.x+1)/16,y=v:ceil(v.y+1)/16,w=v.w/16,h=v.h/16,q=v.v}
                end
            }))
        end
    end
end