
g = {

    w   = nil, -- World
    bc  = nil, -- Badger Components
    c   = nil, -- Game Components
    new =  {}, -- New Entities
    hud = nil,
    h = 3, -- health
    hurt= nil,

    ss = nil, -- spawn system

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

    g.hurt = function()
        g.h -= 1
        g.hud.health = g.h
    end

    g.initBullet()
    g.initPlayer()
    g.initBandit()
    g.initDog()
    g.initKennel()
    g.initSumo()

    g.ss = g.initSpawnSystem()
    g.initSpawners(g.ss) 
    g.sm = g.ss.new.SpawnManager()

    local reset

    local function createResetCondition()

        return g.ss.new.SpawnCond(

            nil,
            function(self, sm) reset(sm) end,
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

    reset(g.sm)

    g.p = g.new.Player(64, 64,
    function (val) g.hud.health = val end,
    function (val) g.hud.ammo   = val end)
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
    g.sm:update(dt)

    --print(g.sm.i .. ", " .. #g.sm.sList, nil, nil, 7)
    --print(g.ce, nil, nil, 7)

    --for _, e in pairs(g.w.query({g.c.Kennel})) do
    --    local hb = e[g.c.Hurtbox]
    --    local ep = e[g.bc.Position]
    --    if hb then hb:draw(8, ep.x, ep.y) end
    --end
end
