
function g.initBullet()

    g.c.Bullet = g.w.component()


    -- bullet conf
    -- some of this is in the conf file
    local c = {

        bbt = conf.p.stunHur, -- bullet block time
    }
    
    
    function g.new.Bullet(x, y, r, angle, speed, c, ic, team, parry)

        local b = g.w.entity()
        
        b += g.bc.new.Position(x, y)
        b += g.bc.new.Velocity(speed * cos(angle), speed * -sin(angle))
        b += g.c.Bullet({r = r, c = c or 8, ic = ic or 7, parry = parry or false})

        -- delete on hit
        b += g.c.new.Hitbox(team or 1, r + 1, nil, nil, 1, 

        function() g.bc.tryDelete(b) end)

        if parry then

            b += g.c.new.Parryable(team or 1, -r, -r, r * 2, r * 2,
                function (me, you) g.bc.tryDelete(me) end)
        end
        
        return b
    end


    local bllBlkTimer = 0

    function g.c.BulletDeleteSystem(dt)
        

        -- end bullet block
        if bllBlkTimer > 0 then

            bllBlkTimer -= dt
        end


        for _, e in pairs(g.w.query({g.c.Bullet, g.bc.Position})) do

            local p = e[g.bc.Position]
            local b = e[g.c.Bullet]

            -- if bullet goes off screen, delete
            if p.x < -b.r or p.x > 128 + b.r or p.y < -b.r or p.y > 128 + b.r then

                g.bc.tryDelete(e)
            end
        end
    end
    
    function g.c.BulletGraphicsSystem()
        
        local q = g.w.query({g.c.Bullet})

        for _, e in pairs(q) do

            local p = e[g.bc.Position]
            local b = e[g.c.Bullet]
            Circle:new(b.r + 1, p.x, p.y):draw(b.c)
        end

        for _, e in pairs(q) do

            local p = e[g.bc.Position]
            local b = e[g.c.Bullet]
            Circle:new(b.r, p.x, p.y):draw(b.ic)
        end
    end


    -- parry bag
    local pBag = {}

    for _, v in pairs(conf.b.paChSe) do

        for i = 1, v - 1 do

            pBag[#pBag + 1] = false
        end
        
        pBag[#pBag + 1] = true
    end


    -- parry bag index
    local pbi = 1

    local function getRandParry()

        local p = pBag[pbi]

        pbi += 1
        if pbi > #pBag then pbi = 1 end

        return p
    end


    function g:shootParry(x, y, r, angle, speed)

        if bllBlkTimer > 0 then return nil end

        local b = self.new.Bullet(
            x, y, r, angle, speed,
            conf.b.pao, conf.b.pai,
            1, true)

        return b
    end


    function g:shootNormal(x, y, r, angle, speed)

        if bllBlkTimer > 0 then return nil end

        local b = self.new.Bullet(
            x, y, r, angle, speed,
            conf.b.eno, conf.b.eni,
            1, false)

        return b
    end
        

    -- shoots enemy bullets. Random chance to be parry
    function g:shoot(x, y, r, angle, speed)

        -- if parry chance true, shoot parry bullet
        local b = getRandParry() and

            g:shootParry(x, y, r, angle, speed) or
            g:shootNormal(x, y, r, angle, speed)

        return b
    end

    function g:blockBullets()
        
        bllBlkTimer = c.bbt
    end
end
