function LoadLevel()
    local level = LEVEL

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