
function g.initDog()

    g.c.Dog = g.w.component()

    
    -- dog conf
    local c = {

        sp = 32, -- speed
        h  =  1, -- health
    }

    function g.new.Dog(x)
        
        local e = g.w.entity()
        
        e += g.bc.new.Position(x, -8)
        e += g.bc.new.Velocity(0, c.sp)
        e += g.bc.new.Sprite(8)
        e += g.c .new.Hurtbox(1, 6)
        e += g.c .new.Health(c.h,
        function (val) if val == 0 then e += g.bc.new.Delete() end end)

        return e
    end
end
