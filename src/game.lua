
g = {

    w   = nil, -- World
    bc  = nil, -- Badger Components
    c   = nil, -- Game Components
    new =  {}, -- New Entities
    hud = nil,
    Health = nil, -- health
    hurt= nil,

    bllBlkTimer = 0, -- bullet block timer

    -- current demo vars:
    sr = 1.75, -- spawn rate
    t = 0, -- time till next spawn
    e = 10, -- enemy count
    ce= 0, -- current wave
}

function g:init()
    
    g.w  = pecs()
    g.bc = getBadgerComponents(g.w)
    g.c  = getGameComponents(g.w, g.bc)
    g.hud= initHud(conf.p.maxAmmo, conf.p.maxHealth)

    g.Health = g.c.new.Health(conf.p.maxHealth, function(val) g.hud.health = val end)
    g.hurt = function() g.Health:hurt(1) end

    g.initBullet()
    g.initPlayer()
    g.initBandit()
    g.initDog()
    g.initKennel()
    g.initSumo()

    g.p = g.new.Player(64, 64, 
    function (val) g.hud.health = val end,
    function (val) g.hud.ammo   = val end)
end

function g:deinit()
    
    g.w = nil
    g.bc = nil
    g.c = nil
end

function g:update(dt)
    
    g.w.update()
    g.bc.PhysicsSystem(dt)

    g.c.PlayerSystem(dt)
    g.c.KennelSystem(dt)
    g.c.SumoSystem(dt)

    g.c.EnemySystem()
    g.c.TickSystem(dt)
    g.c.ParrySystem()
    g.c.HitSystem()
    g.c.BulletDeleteSystem(dt)
    g.bc.DeleteSystem()


    -- sample spawning code
    if g.ce < g.e then

        g.t -= dt

        if g.t <= 0 then

            for i = 0, 16 do

                local m = mget(i, g.ce)

                if m == 7 then

                    g.new.Bandit(i * 8 + 8)

                elseif m == 8 then

                    g.new.Dog(i * 8 + 8)

                elseif m == 9 then

                    g.new.Kennel(i * 8 + 8)

                elseif m == 10 then

                    g.new.Sumo(i * 8 + 8)
                end
            end

            g.t = g.sr
            g.ce += 1
        end
    end
end

function g:draw(dt)
    
    cls(3)
    g.bc.GraphicsSystem()
    g.c.BulletGraphicsSystem()

    local pos = g.p[g.bc.Position]
    local hb  = g.p[g.c.Hurtbox]
    local par = g.p[g.c.ParryDetector]

    hb:draw (11, pos.x, pos.y, true)
    --if par then par:draw(11, pos.x, pos.y, false) end
    g.hud:draw()
    --print(g.ce, nil, nil, 7)

    --for _, e in pairs(g.w.query({g.c.Kennel})) do
    --    local hb = e[g.c.Hurtbox]
    --    local ep = e[g.bc.Position]
    --    if hb then hb:draw(8, ep.x, ep.y) end
    --end
end
