
function g.initSpawners(ss)

    local spawn = {

        [7]  = function(x) return g.new.Bandit (x * 8 + 8) end,
        [8]  = function(x) return g.new.Dog    (x * 8 + 8) end,
        [9]  = function(x) return g.new.Kennel (x * 8 + 8) end,
        [10] = function(x) return g.new.Sumo   (x * 8 + 8) end,
    }

    function ss.spawn(index, x)
        return spawn[index](x)
    end

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

    function ss.new.Spawn(i, x)

        return ss.new.SpawnCond(

            function(self, sm, dt) return true end,

            function(self, sm)

                ss.spawn(i, x) 
                sm.i += 1
            end,
            nil
        )
    end

    -- death condition
    -- i: spawn index, x: x position, r: relative index shift on false
    function ss.new.DeaCon(i, x, r)

        local c
        local s = false -- has spawned yet

        return ss.new.SpawnCond(

            function(self, sm, dt)

                if not s then 

                    c = ss.spawn(i, x)
                    s = true
                end

                return c ~= nil
            end,

            function(self, sm) sm.i += 1 end,
            function(self, sm)
                sm.i += r
            end
        )
    end
end
