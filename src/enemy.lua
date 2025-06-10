
function g.initEnemy()

    g.c.Enemy = g.w.component()

    local hb = g.c.new.Hurtbox (1, 12, nil, nil)

    function g.new.Enemy(x)
        
        local e = g.w.entity()
        
        e += g.bc.new.Position(x, -16)
        e += g.bc.new.Velocity(0, conf.e.speed)
        e += g.bc.new.Sprite(7)
        e += g.c .new.Health(conf.e.h, 
        function (val) if val == 0 then e += g.bc.new.Delete() end end)

        e += g.c.Enemy({t = 16 / conf.e.speed, b = 0, a = nil,
        
        -- if on the left side, strafe right first
        strafe = x < 64})

        return e
    end

    g.c.EnemySystem = g.w.system({g.c.Enemy},

    function (me, dt)

        local pos = me[g.bc.Position]
        local vel = me[g.bc.Velocity]
        local ene = me[g.c.Enemy]

        ene.t -= dt

        if ene.t <= 0 then
            
            vel.y = 0
            vel.x = 0

            -- if burst still remaining...
            if ene.b > 0 then

                -- nil on first bullet
                local ppos = g.p[g.bc.Position]
                if not ene.a then ene.a = atan2(ppos.x - pos.x, pos.y - ppos.y) end

                g:shoot(pos.x, pos.y, 2, ene.a + conf.e.os * (ene.b % 3 - 1), conf.e.bs)
                
                ene.t = conf.e.bt
                ene.b -= 1
                ene.strafe = not ene.strafe

            -- if burst finished...
            else
                ene.t = conf.e.bb
                ene.b = conf.e.bn

                -- stop at cutoff
                if pos.y < conf.cutoff then

                    vel.y = conf.e.speed
                    vel.x = conf.e.strafe * (ene.strafe and 1 or -1)
                end

                if not me[g.c.Hurtbox] then

                    me += hb
                end

                -- reset angle
                ene.a = nil
            end
        end
    end)
end
