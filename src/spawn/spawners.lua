
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

            function(self, sm)

                t = time
                sm.i += 1
            end,

            function(self, sm, dt) t -= dt end
        )
    end

    function ss.new.Spawn(i, x)

        local c

        return ss.new.SpawnCond(

            function(self, sm, dt) return true end,
            function(self, sm) ss.spawn(i, x) end,
            nil
        )
    end
end
