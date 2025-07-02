
conf = {

    p = { -- player
    
        stunRel = 0.4, -- stun on reload
        cancRel = 0.1,  -- cancel reload duration

        stunSho = 0.2,  -- stun duration on shoot
        cancSho = 0.1,  -- cancel shoot duration

        stunHur = 1, -- stun duration on hurt
        backHur = 16, -- knockback distance on hurt

        speed   = 40,
        maxAmmo = 6,
        buff    = 0.6,  -- buffer duration
        health  = 3,
        hRadius = 2,    -- hit radius

        -- parry hitbox size
        paW = 8, -- this is half the width
        paH = 4,

        ammRel = 1, -- amount to reload
        ammPar = 2, -- amount parrying reloads

        -- bullet clear distance
        bcDist = 32,
    },

    aimOff = 0.05, -- aim offset angle

    -- screen cutoff where player cannot go
    -- but enemies stand
    cutoff = 128 - 20,

    b = { -- bullet

        -- sizes
        sml = 1,
        med = 2,
        lrg = 4,

        -- colors
        eno = 8, -- enemy outer
        eni = 7, -- enemy inner

        plo = 6, -- player outer
        pli = 5, -- player inner

        pao = 11,-- parry outer
        pai =  7,-- parry inner

        -- creates a random bag.
        -- e.g. {3,...} means the first 2 won't parry, the 3rd will
        -- then the bag adds on the next values
        paChSe = {6, 12}
    },

    e = { -- enemy

        speed  = 16,
        strafe = 16,
        
        bn = 3,    -- number of bullets fired in a burst
        bt = 0.5,  -- time between bullets in a burst 
        bb = 1.75, -- time between bursts
        bs = 32,   -- bullet speed

        -- offset sizes, small and large
        os = 0.03,
        ol = 0.075,

        h = 2, -- health
    }
}
