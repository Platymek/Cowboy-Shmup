
function g.initSpawnSystem()

    local ss = { new = {} }

    function ss.new.SpawnManager()
    
        return {

            sList = {},
            i = 1,

            enabled = true,

            clear = function(self) 

                self.sList = {}
                self.i = 1
            end,

            add = function(self, ...)

                for _, s in pairs({...}) do

                    self.sList[#self.sList + 1] = s
                end
            end,

            update = function(self, dt)

                if #self.sList == 0 then return end
                if not self.sList[self.i] then return self:clear() end

                local spa = self.sList[self.i]

                local s = false
                if spa.cond then s = spa:cond(self, dt) end

                if s then

                    if spa.success then spa:success(self, dt)
                    else self.i += 1 end

                elseif spa.fail then spa:fail(self, dt)
                end
            end,
        }
    end

    function ss.new.SpawnCond(cond, success, fail)

        return {

            cond = cond,
            success = success,
            fail = fail,
        }
    end

    return ss
end
