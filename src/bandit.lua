
function g.initBandit()

    g.c.Bandit = g.w.component()


    local hb = g.c.new.Hurtbox(1, 6)
    
    -- bandit conf
    local c = {

        s = 1, -- startup time
        b = 1.4, -- bullet time
        sp = 6, -- speed
        bsp = 32, -- bullet speed
    }


    function g.new.Bandit(x)

        local e = g.w.entity()

        e += g.bc.new.Position(x, -8)
        e += g.bc.new.Velocity(0, c.sp)
        e += g.bc.new.Sprite(7)
        e += g.c .new.Health(4,
        function (val) if val == 0 then e += g.bc.new.Delete() end end)

        -- s: startup, b: bullet
        e += g.c.Bandit({s = c.s, b = c.b, flip = false})

        return e
    end

    
    g.c.BanditSystem = g.w.system({g.c.Bandit},

    function(e, dt)

        local ban = e[g.c.Bandit]

        -- startup
        if ban.s > 0 then
        
            ban.s -= dt

            -- finished startup
            if ban.s <= 0 then e += hb end
        end

        local pos = e[g.bc.Position]
        ban.b -= dt

        if ban.b <= 0 then

            ban.b = c.b

            g:shoot(pos.x, pos.y, 2, 0.25, c.bsp)
            g:shoot(pos.x, pos.y, 2, 0.25 + conf.aimOff * (ban.flip and -1 or 1) , c.bsp)

            ban.flip = not ban.flip
        end
    end)
end
