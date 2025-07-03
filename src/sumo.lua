
function g.initSumo()

    g.c.Sumo = g.w.component()

    -- Sumo conf
    local c = {

        sp = 24, -- speed
        h  = 12, -- health

        di = 16, -- slap distance
        fr =  1, -- freeze during slap duration 

        sth=  3, -- stun health (amount of shots before stun)
        std=0.4, -- stun duration

        brd= 48, -- break distance
        brs= 32, -- break speed

        flf=  4, -- flip shoot offset
        shf=  6, -- shoot offset
        bsp= 48, -- bullet speed
    }

    --[[ sumo states:

        0 - push
        1 - freeze
        2 - stun
        3 - break
        4 - pause
    ]]

    function g.new.Sumo(x)

        local e = g.w.entity()
        local pos = g.bc.new.Position(x, -16)
        local vel = g.bc.new.Velocity(0, 0)
        local spg = g.bc.new.SpriteGroup(
            Sprite:new(19, -8, -8, 1, 2), 
            Sprite:new(19,  0, -8, 1, 2, true))

        local sum = g.c.Sumo({
            state = 0, t = 0, flip = false, st = 0})
            
        local hur = g.c.new.Hurtbox(1, 8, nil, nil, function () sum:setState(2) end)
        
        local hea = g.c.new.Health(c.h, 
        function (val) if val == 0 then e += g.bc.new.Delete() end end)

        sum.setState = function (self, state)

            self.state = state
            vel.y = 0

            -- push
            if state == 0 then

                vel.y = c.sp
                self.st = 0
                if not e[g.c.Hurtbox] then e += hur end
                sum.t = c.di / c.sp -- calculate time

            -- freeze
            elseif state == 1 then

                -- if not far down enough, move again
                if pos.y < 16 then return self:setState(0) end

                local off = (self.flip and -c.flf or c.flf)
                g:shoot(pos.x + off - c.shf, pos.y + 8, 2, 0.25 + conf.aimOff / 2, c.bsp)
                g:shoot(pos.x + off, pos.y + 8, 2, 0.25, c.bsp)
                g:shoot(pos.x + off + c.shf, pos.y + 8, 2, 0.25 - conf.aimOff / 2, c.bsp)

                self.flip = not self.flip
                sum.t = c.fr
                
            -- stun
            elseif state == 2 then

                self.st += 1

                if self.st >= c.sth then return self:setState(3) end

                sum.t = c.std

            -- break
            elseif state == 3 then

                e -= g.c.Hurtbox
                vel.y = -c.brs
                sum.t = c.brd / c.brs -- calculate time
            end
        end


        sum.update = function (self, dt)

            local sum = e[g.c.Sumo]
            sum.t -= dt
            print(e[g.c.Hurtbox], nil, nil, 7)

            if sum.t < 0 then
                
                -- idle goes to freeze
                if sum.state == 0 or sum.state == 0 then sum:setState(1) 

                -- freeze, stun, break and push go to idle
                elseif sum.state == 1 or sum.state == 2 or sum.state == 3 then sum:setState(0)
                end
            end
        end


        e += sum
        e += pos
        e += vel
        e += spg
        e += hea
        
        sum:setState(0)

        return e
    end

    g.c.SumoSystem = g.w.system({g.c.Sumo},
    function(e, dt) e[g.c.Sumo]:update(dt) end)
end
