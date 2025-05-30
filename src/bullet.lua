
function g.initBullet()

    g.c.Bullet = g.w.component()
    
    
    function g.new.Bullet(x, y, r, angle, speed, c, ic, team)

        local b = g.w.entity()
        
        b += g.bc.new.Position(x, y)
        b += g.bc.new.Velocity(speed * cos(angle), speed * -sin(angle))
        b += g.c.Bullet({r = r, c = c or 8, ic = ic or 7})
        b += g.c.new.Hitbox(team or 1, r + 1, nil, nil, 1)
        
        return b
    end

    g.c.BulletDeleteSystem = g.w.system({g.c.Bullet, g.bc.Position},
    function (e)

        local p = e[g.bc.Position]
        local b = e[g.c.Bullet]

        if p.x < -b.r or p.x > 128 + b.r or p.y < -b.r or p.y > 128 + b.r then

            e += g.bc.new.Delete()
        end
    end)
    
    function g.c.BulletGraphicsSystem ()
        
        local q = g.w.query({g.c.Bullet})

        for _, e in pairs(q) do

            local p = e[g.bc.Position]
            local b = e[g.c.Bullet]
            Circle:new(b.r + 1, p.x, p.y):draw(b.c)
        end

        for _, e in pairs(q) do

            local p = e[g.bc.Position]
            local b = e[g.c.Bullet]
            Circle:new(b.r, p.x, p.y):draw(b.ic)
        end
    end
end
