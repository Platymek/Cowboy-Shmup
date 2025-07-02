
function g.initSumo()

    g.c.Sumo = g.w.component()

    local setState = function (self, state)


    end

    function g.new.Sumo(x)

        local e = g.w.entity()

        e += g.c.Sumo({state = 0, setState = setState})
        e += g.bc.Position(x, -16)
        e += g.bc.new.SpriteGroup(
            Sprite:new(19, -8, -8, 1, 2), 
            Sprite:new(19,  0, -8, 1, 2, true))
    end
end
