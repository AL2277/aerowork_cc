local std = require("std")

local class = {classes = {}}

function class:new(name)
    local cls = {}
    if self.classes[name] == nil then
        self.classes[name] = cls
    else
        -- error("duplicate id for classes")
        local i = 0
        repeat
            -- `class_0` seems weird when `class` already exist
            i = i + 1
        until (self.classes[name .. "_" .. i] ~= nil)
        name = name .. "_" .. i
        self.classes[name] = cls
    end

    cls.__cls = name
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
        function (c, arg)
            local obj = c[name](c, arg)
            setmetatable(obj, c)
            return obj
        end

    setmetatable(cls, {
        __call = cls.new
    })

    return cls
end

setmetatable(class, {__call = class.new})

local function my_type(obj)
    if type(obj) == "table" then
        return obj.__cls or "table"
    else
        return type(obj)
    end
end


return {class = class, my_type = my_type}