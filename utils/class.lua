local class = {}

function class:new(name)
    local cls = {
    }
    cls.__name = name
    cls.__index =
        function (o, k)
            if cls[k] ~= nil then
                return cls[k]
            else
                return cls.__get(o, k)
            end
        end
    cls.__newindex =
        function (o, k, v)
            if rawget(o, k) ~= nil then
                o[k] = v
                return
            else
                cls.__set(o, k, v)
                return
            end
        end
    cls.new =
        function (c, ...)
            local obj = c[name](c, ...)
            setmetatable(obj, c)
            return obj
        end
            -- function (o, k)
            --     if rawget(o, k) ~= nil then
            --         return rawget(o, k)
            --     elseif k == "__newindex" then
            --         return o.__set
            --     else
            --         return o.__get(k)
            --     end
            -- end
    return cls
end

return class