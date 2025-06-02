
function g.initPlayer()

    g.c.Player = g.w.component()
    

    --[[states:
    
        0 - idle
        1 - reload
        2 - shoot left
        3 - shoot
        4 - shoot right
    ]]

    
    function g.new.Player(x, y, onHealthChange, onAmmoChange)

        local p = g.w.entity()
        
        p += g.bc.new.Position(x, y)
        p += g.bc.new.Velocity()
        p += g.bc.new.Sprite(1, -4, -4, 1, 1)

        p += g.c.new.Hurtbox(0, conf.p.hRadius, nil, nil,
        function (me, you) local ypos = you[g.bc.Position] end)

        p += g.c.new.Health(conf.p.health,
        function (val) call(onHealthChange, val) end)

        p += g.c.Player({

            state   = 0, -- player state
            stun    = 0, -- remaining stun time
            buff    = 0, -- remaining action buffer time
            action  = 0, -- buffered action
            pressed = false, -- if action is pressed (blocks holding)
            
            ammo    = conf.p.maxAmmo, -- remaining ammo
            maxAmmo = conf.p.maxAmmo, -- remaining ammo

            buffAction = function (self, action)

                self.action = action
                self.buff = conf.p.buff
            end,

            checkBuff = function (self)

                if self.buff > 0 then
                    
                    self.buff = 0
                    self:setState(self.action)
                    return true
                end

                -- false if no action is buffered
                return false
            end,

            setState = function (self, state)

                self.state = state

                -- idle
                if state == 0 then

                    self.stun = 0
                    self:checkBuff()
                end

                -- reload
                if state == 1 then
                    
                    self.stun = conf.p.stunRel
                end

                -- shoot
                if state > 1 then
                    
                    self.ammo -= 1
                    call(onAmmoChange, self.ammo)

                    self.stun = conf.p.stunSho
                    
                    local pos = p[g.bc.Position]
                    g.new.Bullet(
                        pos.x, pos.y - 8, 2,
                        0.75 + (state - 3) * conf.aimOff,
                        128, 8, 2, 0)
                end
            end,
        })
        
        return p
    end
    

    g.c.PlayerSystem = g.w.system({g.c.Player},

    function (e, dt)
        
        local pos = e[g.bc.Position]
        local pla = e[g.c.Player]
        local vel = e[g.bc.Velocity]


        -- action buffering

        if pla.buff > 0 then pla.buff -= dt end

        if not pla.pressed then

            if      btn(❎) then 

                if      btn(⬅️) then pla:buffAction(2)
                elseif  btn(➡️) then pla:buffAction(4)
                else pla:buffAction(3) 
                end

            elseif  btn(🅾️) then pla:buffAction(1)
            end

            if btn(❎) or btn(🅾️) then pla.pressed = true
            end

        elseif not btn(❎) and not btn(🅾️) then 
            
            pla.pressed = false
        end


        -- idle
        if pla.state == 0 then

            vel.x = 0
            vel.y = 0
            
            if not pla:checkBuff() then

                local x = 0
                local y = 0

                if btn(0) then
                    x -= 1
                end
                if btn(1) then
                    x += 1
                end
                if btn(2) then
                    y -= 1
                end
                if btn(3) then
                    y += 1
                end

                if x ~= 0 or y ~= 0 then
                    
                    local a = atan2(x, y)
                    vel.x = cos(a) * conf.p.speed
                    vel.y = sin(a) * conf.p.speed
                end
            end

        elseif pla.stun > 0 then

            pla.stun -= dt
        else
            pla:setState(0)
        end
    end)
end
