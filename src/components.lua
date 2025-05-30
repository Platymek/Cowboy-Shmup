

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
		return hb
    end

    function c.new.Hurtbox(team, r, x, y, onHurt)

		return getBox(c.Hurtbox, team, r, x, y, onHurt)
    end
    

    -- systems

    c.HitSystem = w.system({c.Hitbox, bc.Position}, 
    
    function (ent)
        
        local hit = ent[c.Hitbox]
        local pos = ent[bc.Position]
        local off = hit:getOffset(pos.x, pos.y)

        -- for all entities of a different team with a hurtbox
        for _, hurtEnt in pairs(w.query({c.Hurtbox, bc.Position})) do
        if hurtEnt ~= ent then

            local hurt   = hurtEnt[c.Hurtbox]
            local hPos   = hurtEnt[bc.Position]
            local health = hurtEnt[c.Health]
            local hOff   = hit:getOffset(hPos.x, hPos.y)

            if (hit.team ~= hurt.team or not hit.team or not hurt.team)
            and off:isOverlapping(hOff) then

                if hit.onHurt then
                    call(hit.onHurt,  ent, hurtEnt)
                end

                if hurt.onHurt then
                    call(hurt.onHurt, hurtEnt, ent)
                end
                
                -- damage if has health component
                if health then health:hurt(hit.dam) end
            end
        end end
    end)


    return c
end
