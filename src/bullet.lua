
function g.initBullet()

    g.c.Bullet = g.w.component()
    
    
    function g.new.Bullet(x, y, r, angle, speed, c)

        local b = g.w.entity()
        
        b += g.bc.new.Position(x, y)
        b += g.bc.new.Velocity(speed * cos(angle), speed * sin(angle))
        b += g.c.Bullet({r = r, c = c or 8})
        
        return b
    end
    

    g.c.BulletGraphicsSystem = g.w.system({g.bc.Position, g.c.Bullet},

    function (e)
        
        local p = e[g.bc.Position]
        local b = e[g.c.Bullet]
        circfill(p.x, p.y, b.r + 1, b.c)
        circfill(p.x, p.y, b.r, 7)
    end)
end
