
function g.initSpawners(ss)

    ene = {

        Bandit = 7,
        Dog    = 8,
        Kennel = 9,
        Sumo   = 10,
    }

    local spawn = {

        [ene.Bandit]= function(x) return g.new.Bandit (x * 8 + 8) end,
        [ene.Dog]   = function(x) return g.new.Dog    (x * 8 + 8) end,
        [ene.Kennel]= function(x) return g.new.Kennel (x * 8 + 8) end,
        [ene.Sumo]  = function(x) return g.new.Sumo   (x * 8 + 8) end,
    }

    function ss.spawn(index, x)

        return spawn[index](x)
    end

    function ss.spawnLine(mx, my, x)

        for i = 0, 16 do
        
            spawn[mget(mx * 16 + i, my)](x)
        end
    end

    -- pause for a set time, then next condition
    function ss.new.Timer(time)

        local t = time

        return ss.new.SpawnCond(

            function(self, sm, dt) 

                return t <= 0
            end,

            function(self, sm, dt) 

                t = time
                sm.i += 1
            end,

            function(self, sm, dt) t -= dt end
        )
    end

    -- spawn a new enemy, i: spawn index, x: x position
    function ss.new.Spawn(i, x)

        return ss.new.SpawnCond(

            nil,
            function(self, sm)

                ss.spawn(i, x) 
                sm.i += 1
            end,
            nil
        )
    end

    function ss.new.SpawnLine(mx, my)
    
        return ss.new.SpawnCond(

            nil,
            function(self, sm)

                ss.spawnLine(mx, my)
            end
        )
    end

    -- increments spawn index by i
    function ss.new.Skip(i)
    
        return ss.new.SpawnCond(

            nil,
            function(self, sm) sm.i += i end,
            nil
        )
    end

    -- death condition
    -- i: spawn index, x: x position, r: relative index shift on false
    function ss.new.DeaCon(i, x, r)

        local d = false -- has died yet
        local s = false -- has spawned yet

        return ss.new.SpawnCond(

            function(self, sm, dt)

                if not s then 

                    c = ss.spawn(i, x)

                    -- on delete, fulfill condition
                    local f = function () d = true end
                    g.bc.addOnDel(c, f)

                    s = true
                end

                return d
            end,

            nil,
            function(self, sm) sm.i += r end
        )
    end
end
