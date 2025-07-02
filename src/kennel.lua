
function g.initKennel()

    g.c.Kennel = g.w.component()


    local c = {

        -- speed
        sp = 16,
        -- startup
        s  = 2,
        -- dog rate
        d  = 6,
        -- health
        h  = 8,
    }


    local hb = g.c.new.Hurtbox(1, 8)


    function g.new.Kennel(x)

        e = g.w.entity()

        e += g.c.Kennel({d = c.d, s = c.s})
        
        e += g.bc.new.SpriteGroup(
            Sprite:new(18, -8, -8, 1, 2), 
            Sprite:new(18,  0, -8, 1, 2, true))

        e += g.bc.new.Position(x, -16)
        e += g.bc.new.Velocity(0,c.sp)
        e += g.c.new.Health(c.h,
        function (val) if val == 0 then e += g.bc.new.Delete() end end)

        return e
    end


    g.c.KennelSystem = g.w.system({g.c.Kennel},

    function(e, dt)

        local ken = e[g.c.Kennel]

        if ken.s > 0 then

            ken.s -= dt

            if ken.s < 0 then

                e[g.bc.Velocity].y = 0
                e += hb
            end
        end

        if ken.d > 0 then

            ken.d -= dt

            if ken.d < 0 then

                ken.d = c.d

                local pos = e[g.bc.Position]
                g.new.Dog(pos.x)[g.bc.Position].y = pos.y
            end
        end
    end)
end
