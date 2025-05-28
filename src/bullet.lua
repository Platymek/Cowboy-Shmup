
function g.initBullet()

    g.c.Bullet = g.w.component()
    
    
    function g.new.Bullet(x, y, r, angle, speed, c, ic)

        local b = g.w.entity()
        
        b += g.bc.new.Position(x, y)
        b += g.bc.new.Velocity(speed * cos(angle), speed * -sin(angle))
        b += g.c.Bullet({r = r, c = c or 8, ic = ic or 7})
        
        return b
    end
    
    function g.c.BulletGraphicsSystem ()
        
        local q = g.w.query({g.c.Bullet})

        for _, e in pairs(q) do

            local p = e[g.bc.Position]
            local b = e[g.c.Bullet]
            circfill(p.x, p.y, b.r + 1, b.c)
        end

        for _, e in pairs(q) do

            local p = e[g.bc.Position]
            local b = e[g.c.Bullet]
            circfill(p.x, p.y, b.r, b.ic)
        end
    end
end
