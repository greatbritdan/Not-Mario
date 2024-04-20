return {
    player={
        img = "player", quad = 3,
        ox = -.125, oy = -.6875
    },
    floor={
        img = "tiles", quad = 1,
        resize = {true,true}
    },
    block={
        img = "tiles", quad = 2,
        resize = {true,true}
    },
    pipe={
        img = "tiles",
        quad = function(x,y) return Tilequads[(y*2)+x] end,
        resize = {false,true}
    }
}