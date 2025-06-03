
function g.initPlayer()

    g.c.Player = g.w.component()
    

    --[[states:
    
        0 - idle
        1 - reload
        2 - shoot left
        3 - shoot
        4 - shoot right
    ]]


    local ps = Sprite:new(1,  -4, -4) -- player
    local gs = Sprite:new(6, -12, -12) -- gun

    -- team, x, y, w, h, onParry
    local pa = g.c.new.ParryDetector(0,

        -- dimensions
        -conf.p.paW, -conf.p.paH * 2 - 4,
        conf.p.paW * 2, conf.p.paH * 2,

        -- restore all ammo on parry
        function (me, you) me[g.c.Player]:setAmmo(999) end)

    
    function g.new.Player(x, y, onHealthChange, onAmmoChange)

        local p = g.w.entity()
        
        p += g.bc.new.Position(x, y)
        p += g.bc.new.Velocity()


        local sg = g.bc.new.SpriteGroup(ps)
        p += sg

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

                    -- only shoot if enough ammo
                    if (self.action >= 2 and self.ammo > 0) or 
                        self.action == 1 then

                        self:setState(self.action)
                    end

                    return true
                end

                -- false if no action is buffered
                return false
            end,


            setAmmo = function(self, val)

                self.ammo = min(val, conf.p.maxAmmo)
                call(onAmmoChange, self.ammo)
            end,


            setState = function (self, enter)

                local exit = self.state
                self.state = enter

                -- idle
                if enter == 0 then

                    self.stun = 0
                    self:checkBuff()
                end

                -- reload
                if exit == 1 then

                    -- remove parry detector
                    if p[g.c.ParryDetector] then
                        p -= g.c.ParryDetector
                    end

                    sg:remove(gs)
                end
                if enter == 1 then
                    
                    self.stun = conf.p.stunRel
                    self:setAmmo(self.ammo + 1)
                    
                    -- add parry detector
                    if not p[g.c.ParryDetector] then
                        p += pa
                    end

                    -- add gun sprite
                    gs.x = -12
                    sg:add(gs)
                end

                -- shoot
                if enter > 1 then
                    
                    self.stun = conf.p.stunSho
                    self:setAmmo(self.ammo - 1)
                    
                    -- shoot bullet
                    local pos = p[g.bc.Position]
                    g.new.Bullet(
                        pos.x, pos.y - 8, 2,
                        0.75 + (enter - 3) * conf.aimOff,
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
            
            -- reload animation
            if pla.state == 1 then

                -- slide gun from left to right, stopping when can cancel
                gs.x = 4 + -16 * max((pla.stun - conf.p.cancRel) / (conf.p.stunRel - conf.p.cancRel), 0)
            end

            -- cancel reload or shoot based on cancel period
            if pla.stun <= (pla.state == 1 and conf.p.cancRel or conf.p.cancSho)
            then pla:checkBuff() end
        else
            pla:setState(0)
        end
    end)
end
