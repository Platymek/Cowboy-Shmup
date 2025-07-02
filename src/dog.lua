
function g.initDog()

    g.c.Dog = g.w.component()

    
    -- dog conf
    local c = {

        sp = 32, -- speed
        h  =  1, -- health
        b  =  2, -- bullet rate
    }

    function g.new.Dog(x)
        
        local e = g.w.entity()
        
        e += g.bc.new.Position(x, -8)
        e += g.bc.new.Velocity(0, c.sp)
        e += g.bc.new.Sprite(8)
        e += g.c .new.Hurtbox(1, 6)
        e += g.c .new.Health(c.h,
        function (val) if val == 0 then e += g.bc.new.Delete() end end)

        e += g.c.Dog({b = 0})

        return e
    end


    g.c.DogSystem = g.w.system({g.c.Dog},

    function(e, dt)
    
        local dog = e[g.c.Dog]

        dog.b -= dt

        if dog.b <= 0 then
            
            dog.b = c.b

            local pos = e[g.bc.Position]
            g:shoot(pos.x, pos.y, 2, 0.25, c.sp * 0.75)
        end
    end)
end
