
conf = {

    p = { -- player
    
        stunRel = 0.5, -- stun on reload
        cancRel = 0.1,  -- cancel reload duration

        stunSho = 0.3,  -- stun duration on shoot
        cancSho = 0.1,  -- cancel shoot duration

        speed   = 32,
        maxAmmo = 6,
        buff    = 0.4,  -- buffer duration
        health  = 3,
        hRadius = 2,    -- hit radius

        -- parry hitbox size
        paW = 8, -- this is half the width
        paH = 4,
    },

    aimOff = 0.075, -- aim offset angle

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
        paChSe = {3, 5, 4}
    },
}
