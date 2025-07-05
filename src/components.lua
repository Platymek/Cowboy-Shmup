
function getGameComponents(w, bc)

    local c = {
        
        new = {},
    }


    -- health component

    c.Health = w.component()

    function c.new.Health(max, onHurt, val)

        local h = c.Health({
        
            max = max,          -- maximum health
            onHurt = onHurt,    -- func/s to call when hurt
            val = val or max,   -- current health

            hurt = function (self, val)

                self.val -= val or 1

                if self.val < 0 then
                    self.val = 0
                end

                if self.onHurt then call(self.onHurt, self.val) end
            end,
        })

        return h
    end


    -- hitbox and hurtbox components

    c.Hitbox  = w.component()
    c.Hurtbox = w.component()

    local function getBox(box, team, r, x, y, onHurt)

		local cir = Circle:new(r, x or 0, y or 0)

        local h = box({

            team = team,     -- team of the hitbox
            onHurt = onHurt, -- function to call when hitbox hurts something
        })

        setmetatable(h, {__index = cir})

		return h
    end

    function c.new.Hitbox(team, r, x, y, dam, onHurt)

        local hb = getBox(c.Hitbox, team, r, x, y, onHurt)
        
        hb.dam = dam or 1 -- damage dealt by the hitbox
        hb.hit = {} -- entities currently inside hitbox

		return hb
    end

    function c.new.Hurtbox(team, r, x, y, onHurt)

		return getBox(c.Hurtbox, team, r, x, y, onHurt)
    end


    -- parry components

    c.Parryable = w.component()
    c.ParryDetector = w.component()

    local function getPar(par, team, x, y, w, h, onParry)
        
		local rect = Rectangle:new(x or -4, y or -4, w or 8, h or 8)

        local p = par({
        
            team = team,     -- team of the parryable
            onParry = onParry, -- function to call when parried
        })

		setmetatable(p, {__index = rect})

        return p
    end

    function c.new.Parryable(team, x, y, w, h, onParry)

        return getPar(c.Parryable, team, x, y, w, h, onParry)
    end

    function c.new.ParryDetector(team, x, y, w, h, onParry)

        local p = getPar(c.ParryDetector, team, x, y, w, h, onParry)

        p.hit = {} -- entities currently inside parry detector
        
        return p
    end


    -- Tick component

    c.Tick = w.component()

    function c.new.Tick(t, onTick)

        return c.Tick({
        
            t = t, -- remaining time
            onTick = onTick, -- function to call when ticked
        })
    end
    

    -- systems

    c.HitSystem = w.system({c.Hitbox, bc.Position}, 
    
    function (ent)
        
        local hit = ent[c.Hitbox]
        local pos = ent[bc.Position]
        local off = hit:getOffset(pos.x, pos.y)

        -- currently in hitbox
        local curHit = {}

        -- for all entities of a different team with a hurtbox
        for _, hurtEnt in pairs(w.query({c.Hurtbox, bc.Position})) do
        if hurtEnt ~= ent then

            local hurt   = hurtEnt[c.Hurtbox]
            local hPos   = hurtEnt[bc.Position]
            local hOff   = hurt:getOffset(hPos.x, hPos.y)

            if (hit.team ~= hurt.team or not hit.team or not hurt.team)
            and off:isOverlapping(hOff) then

                -- sets don't exist in lua
                curHit[hurtEnt] = true
            end
        end end

        -- for all entities currently in hitbox
        for e, _ in pairs(curHit) do

            -- hit if has not already
            if not hit.hit[e] then
                
                local hurt = e[c.Hurtbox]

                -- callbacks
                if hit .onHurt then call(hit .onHurt, ent, e) end
                if hurt.onHurt then call(hurt.onHurt, e, ent) end
                
                -- damage if has health component
                local health = e[c.Health]
                if health then health:hurt(hit.dam) end

                hit.hit[e] = true
            end
        end

        -- remove entities that are no longer in hitbox
        for e, _ in pairs(hit.hit) do hit.hit[e] = curHit[e] or nil end
    end)


    c.ParrySystem = w.system({c.ParryDetector, bc.Position},

    function (me)
        
        local parrier = me[c.ParryDetector]
        local mePos   = me[bc.Position]
        local meOff   = parrier:getOffset(mePos.x, mePos.y)
        

        -- currently in parry detector
        local curPar = {}

        for _, yo in pairs(w.query({c.Parryable, bc.Position})) do

            local parrble = yo[c.Parryable]
            local yoPos   = yo[bc.Position]
            local yoOff   = parrble:getOffset(yoPos.x, yoPos.y)


            if (parrier.team ~= parrble.team or not parrier.team or not parrble.team)
            and meOff:isOverlapping(yoOff) then

                -- sets don't exist in lua
                curPar[yo] = true
            end
        end


        -- for all entities currently in parry detector
        for yo, _ in pairs(curPar) do

            -- parry if not already
            if not parrier.hit[yo] then

                local parrble = yo[c.Parryable]

                -- callbacks
                if parrier.onParry then call(parrier.onParry, me, yo) end
                if parrble.onParry then call(parrble.onParry, yo, me) end

                parrier.hit[yo] = true
            end
        end

        -- remove entities that are no longer in hitbox
        for yo, _ in pairs(parrier.hit) do parrier.hit[yo] = curPar[yo] or nil end
    end)


    c.TickSystem = w.system({c.Tick},

    function (ent, dt)

        local tick = ent[c.Tick]


        if tick.t <= 0 then return end

        tick.t -= dt

        -- call onTick if time is up
        if tick.t <= 0 and tick.onTick then call(tick.onTick, tick) end
    end)


    return c
end
