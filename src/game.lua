
g = {

    w   = nil, -- World
    bc  = nil, -- Badger Components
    c   = nil, -- Game Components
    new =  {}, -- New Entities
    hud = nil,

    t = 0, -- Time (for tests)
    i = 0, -- Index (for tests)
}

function g:init()
    
    g.w  = pecs()
    g.bc = getBadgerComponents(g.w)
    g.c  = getGameComponents(g.w, g.bc)
    g.hud= initHud()

    g.initBullet()
    g.initPlayer()

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
    g.c.HitSystem()
    g.c.BulletDeleteSystem()
    g.bc.DeleteSystem()

    g.t -= dt

    if g.t <= 0 then

        local a = 0.25
        local s = 16

        g.t = 2
        g:shoot(64, 0, 2, a - conf.aimOff, s)
        g:shoot(64, 0, 2, a, s)
        g:shoot(64, 0, 2, a + conf.aimOff, s)
    end
end

function g:draw()
    
    cls(3)
    g.bc.GraphicsSystem()
    g.c.BulletGraphicsSystem()


    local pos = g.p[g.bc.Position]
    local hb  = g.p[g.c.Hurtbox]

    hb:draw(11, pos.x, pos.y, true)
    g.hud:draw()
end
