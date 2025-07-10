
function g.initBandit()

    g.c.Bandit = g.w.component()


    local hb = g.c.new.Hurtbox(1, 6)
    
    -- bandit conf
    local c = {

        s = 1, -- startup time
        b = 1.4, -- bullet time
        sp = 6, -- speed
        bsp = 32, -- bullet speed
        h = 3 -- health
    }


    function g.new.Bandit(x)

        local e = g.w.entity()

        local pos = g.bc.new.Position(x, -8)
        -- s: startup, b: bullet
        local ban = g.c.Bandit({f = false, s = true})

        e += g.c.new.Tick(c.s, function (self)
        
            if ban.s then
                
                e += hb
                ban.s = false
                self.t = c.b
                return
            end

            self.t = c.b

            g:shoot(pos.x, pos.y, 2, 0.25, c.bsp)
            g:shoot(pos.x, pos.y, 2, 0.25 + conf.aimOff * (ban.f and -1 or 1) , c.bsp)

            ban.f = not ban.f
        end)
        
        e += ban
        e += pos
        e += g.c .new.Enemy()
        e += g.bc.new.Velocity(0, c.sp)
        e += g.bc.new.Sprite(7)
        e += g.c .new.Health(c.h,
        function (val) if val == 0 then g.bc.tryDelete(e) end end)

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
