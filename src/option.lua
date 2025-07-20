
function g.initOpt()

    g.c.Opt = g.w.component()
    
    local c = {

        -- padding
        p = 1
    }

    function textW(text) return #text * 4 - 1 end
    function textH(text) return 5 end

    function g.new.Opt(x, y, text, onHit)
    
        local e = g.w.entity()
        local r = textW(text) / 2

        e += g.bc.new.Position(x, y)
        e += g.c.Opt({text = text})
        e += g.c.new.Hurtbox(1, r + c.p * 2, r + c.p, 0, onHit)

        return e
    end

    g.c.OptGraphicSys = g.w.system({g.c.Opt},

    function(e) 
        
        local op = e[g.c.Opt]
        local po = e[g.bc.Position]
        local hb = e[g.c.Hurtbox]

        hb:draw(1, po.x, po.y)
        print(op.text, po.x + c.p, po.y + c.p, 7)
    end)
end
