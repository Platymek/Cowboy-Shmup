
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
end

function g:deinit()
    
    g.w = nil
    g.bc = nil
    g.c = nil
end

function g:update(dt)
    
    g.w.update()
    g.bc.PhysicsSystem(dt)

    g.t += dt

    if g.t > 0.1 then

        g.t = 0
        g.new.Bullet(64, 64, 2, g.i * 0.1, 16)
        g.i += 1
    end
end

function g:draw()
    
    g.bc.GraphicsSystem()
    g.c.BulletGraphicsSystem()
end
