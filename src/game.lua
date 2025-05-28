
g = {

    w = nil,  -- World
    bc = nil, -- Badger Components
}

function g:initialiseGame()
    
    g.w = pecs()
    g.bc = getBadgerComponents(g.w)
    g.c = getGameComponents(g.w, g.bc)
end

function g:update(dt)
    
    g.w.update()
    g.bc.PhysicsSystem(dt)
end

function g:draw()
    
    g.bc.GraphicsSystem()
end
