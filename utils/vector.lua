local class = require("class")

local vector = class:new("vector")

function vector:vector(arr)
    local obj = {
        array = {},
        length = 0
    }
    if arr ~= nil then
        for _,v in ipairs(arr) do
            obj.array[obj.length] = v
            obj.length = obj.length + 1
        end
    end
    return obj
end

function vector:push_back(v)
    self.array[self.length] = v
    self.length = self.length + 1
end

function vector:pop_back()
    if self.length == 0 then
        error("cannot pop from empty vector")
    end
    self.length = self.length - 1
    self.array[self.length] = nil
end

function vector:__tostring()
    if self.length == 0 then
        return "[]"
    end
    local str = "[" ..  self.array[0]
    for i=1,self.length-1 do
        str = str .. ", " .. self.array[i]
    end
    return str .. "]"
end

function vector:__get(i)
    if type(i) ~= "number" then
        error("invalid index type for vector")
    end
    i = math.floor(i)
    if i < 0 or i >= self.length then
        error("index out of range")
    end
    return self.array[i]
end

function vector:__set(i, v)
    if type(i) ~= "number" then
        error("invalid index type for vector")
    end
    i = math.floor(i)
    if i < 0 or i >= self.length then
        error("index out of range")
    end
    self.array[i] = v
end


-- local a = vector:new()
-- local b = vector:new({1,2})
-- print(a)
-- print(b)

-- a:push_back(3)
-- b:push_back(4)
-- print(a)
-- print(b)

-- b:pop_back(4)
-- print(b)
-- print(b[1])
-- b[0] = 9
-- print(b)

return vector