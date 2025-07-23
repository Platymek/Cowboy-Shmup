
waves = {

    proto = function (sm)

        local reset

        local function createResetCondition()

            return g.ss.new.SpawnCond(

                nil,
                function(self, sm) 

                    reset(sm)
                end,
                nil
            )
        end

        reset = function(sm)

            sm:clear()
            
            sm:add(

                g.ss.new.Skip(7),

                g.ss.new.Timer(4),
                g.ss.new.Spawn(ene.Dog, 9),
                g.ss.new.Spawn(ene.Bandit, 4),

                g.ss.new.Timer(4),
                g.ss.new.Spawn(ene.Dog, 4),
                g.ss.new.Spawn(ene.Bandit, 9),

                g.ss.new.DeaCon(ene.Sumo, 7, -6),

                createResetCondition()
            )
        end

        g.sm:add(
            g.ss.new.SpawnCond(

                nil,
                function(self, sm) 

                    local op

                    op = g.new.Opt(16, 16, "play", function() 

                        reset(g.sm)
                        g.bc.tryDelete(op)
                    end)

                    sm.i += 1
                end,
                nil
            )
        )
    end,

    [1] = function (sm)
        
        sm:add(

            --[[
            g.ss.new.Timer(1),
            g.ss.new.SpawnLine(0, 0),
            g.ss.new.Timer(3),
            g.ss.new.SpawnLine(0, 1),
            g.ss.new.Timer(1),
            g.ss.new.DeaCon(ene.Bandit, 7, 0),

            g.ss.new.Timer(3),

            -- triple assualt left
            g.ss.new.SpawnLine(0, 2),
            g.ss.new.Timer(1),
            g.ss.new.SpawnLine(0, 3),
            g.ss.new.Timer(1),
            g.ss.new.SpawnLine(0, 4),

            g.ss.new.Timer(3),

            -- triple assualt right
            g.ss.new.SpawnLine(0, 5),
            g.ss.new.Timer(1),
            g.ss.new.SpawnLine(0, 6),
            g.ss.new.Timer(1),
            g.ss.new.DeaCon(ene.Bandit, 10, 0),

            -- dogs r to l
            g.ss.new.SpawnLine(0, 8),
            g.ss.new.Timer(0.5),
            g.ss.new.SpawnLine(0, 9),
            g.ss.new.Timer(0.5),
            g.ss.new.SpawnLine(0, 10),
            g.ss.new.Timer(2),


            -- triple threat and 3 dogs in center
            -- bandits
            g.ss.new.SpawnLine(0, 11),
            g.ss.new.Timer(0.5),
            g.ss.new.SpawnLine(0, 12),
            g.ss.new.Timer(0.5),
            g.ss.new.SpawnLine(0, 13),

            g.ss.new.Timer(2),
            -- dogs
            g.ss.new.SpawnLine(0, 14),
            g.ss.new.Timer(0.5),
            g.ss.new.SpawnLine(0, 15),
            g.ss.new.Timer(0.5),
            g.ss.new.SpawnLine(0, 16),
            ]]

            -- death condition bandit
            g.ss.new.Timer(1),
            g.ss.new.DeaCon(ene.Bandit, 7, 0),
            g.ss.new.SpawnLine(0, 18),


            -- kennel intro
            g.ss.new.Timer(1),
            g.ss.new.Skip(5), -- skip to kennel death condition
            g.ss.new.Timer(3),
            g.ss.new.SpawnLine(0, 20),
            g.ss.new.Timer(3),
            g.ss.new.SpawnLine(0, 21),
            g.ss.new.DeaCon(ene.Kennel, 7, -4), -- skip back to spawning bandits

            nil
        )
    end
}
