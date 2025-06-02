
function initHud(ammo, health)

    -- h: health, m: max
    local function drawH(x, y, h, m)
        
        rectfill(x, y, x + 9, y + m * 8, 0)

        for i = 1, m do

            -- draw heart or empty
            spr(i <= h and 3 or 2, x + 1, y + (i - 1) * 8)
        end
    end
    
    -- a: ammo, m: max
    local function drawA(a, m)
        
        local x = 64 - m * 8 / 2
        local y = 116

        rectfill(x - 1, y - 1, x + m * 8, y + 8, 0)

        for i = 1, m do

            -- draw heart or empty
            spr(i <= a and 5 or 4, (i - 1) * 8 + x, y)
        end
    end

    local hud = {

        ammo   = ammo   or conf.p.maxAmmo,
        health = health or conf.p.health,

        draw = function (self)

            drawH(2, 2, self.health, conf.p.health)
            drawA(self.ammo, conf.p.maxAmmo)
        end
    }

    return hud
end
