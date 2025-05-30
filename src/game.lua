
g = {

    w = nil,  -- World
    bc = nil, -- Badger Components
    c = nil,  -- Game Components
    new = {}, -- New Entities

    t = 0,    -- Time (for tests)
    i = 0,    -- Index (for tests)
}

function g:init()
    
    g.w = pecs()
    g.bc = getBadgerComponents(g.w)
    g.c = getGameComponents(g.w, g.bc)

    g.initBullet()
    g.initPlayer()

    g.p = g.new.Player(64, 64)
    
    b = g.w.entity()
    b += g.bc.new.Position(32, 32)
    b += g.c.new.Hitbox(1, 4)
    b += g.bc.new.Sprite(1)
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
        g.new.Bullet(64, 0, 2, a - conf.aimOff, s)
        g.new.Bullet(64, 0, 2, a, s)
        g.new.Bullet(64, 0, 2, a + conf.aimOff, s)
    end
end

function g:draw()
    
    g.bc.GraphicsSystem()
    g.c.BulletGraphicsSystem()


    local pos = g.p[g.bc.Position]
    local hb  = g.p[g.c.Hurtbox]

    hb:draw(11, pos.x, pos.y, true)


    for _, e in pairs(query({g.c.Hitbox, g.c.Position})) do

        local pos = e[g.bc.Position]
        local hb  = e[g.c.Hitbox]

        hb:draw(11, pos.x, pos.y, true)
        --pset(pos.x, pos.y, 11)
    end

    local bpos = b[g.bc.Position]
    local bhb  = g.p[g.c.Hurtbox]
    bhb:draw(11, bpos.x, bpos.y, true)
    print(b[g.bc.Position]:distanceSquared(g.p[g.bc.Position]), 0, 0, 7)
end
