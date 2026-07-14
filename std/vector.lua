local std = require("std")
std.include("class")
std.include("container")

local vector = std.class:new("vector")

function vector:vector(arg)
    local arr = arg.arr or arg[1]
    local length = arg.length or arg[1]
    local default = arg.default or arg[2] or 0

    local obj = {
        array = {},
        length = 0,
        default = default
    }
    if std.is_iterable(arr) then
        for v in std.iter(arr) do
            obj.array[obj.length] = v
            obj.length = obj.length + 1
        end
    elseif type(length) == "number" and length >= 1 then
        obj.length = math.floor(length)
        for i=0,obj.length-1 do obj.array[i] = default end
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
    local value = self.array[self.length]
    self.array[self.length] = nil
    return value
end

function vector:empty()
    return self.length == 0
end

-- resize to length l
-- delete extra entry if l < length
-- fill with default if l > length
function vector:resize(l)
    if l < self.length then
        for i=l,self.length-1 do self.array[i] = nil end
    elseif l > self.length then
        for i=self.length, l-1 do self.array[i] = self.default end
    end
    self.length = l
end

function vector:swap(i, j)
    i = math.floor(i)
    j = math.floor(j)
    if i < 0 or j < 0 or i >= self.length or j >= self.length then
        error("Index out of bound")
    end
    self.array[i], self.array[j] = self.array[j], self.array[i]
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

local vector_iterator = std.class("vector_iterator")
function vector_iterator:vector_iterator(arg)
    local vec = arg.vec or arg[1]
    local ind = arg.ind or arg[2] or 0

    local obj = {vec = vec, ind = ind}

    return obj
end

function vector_iterator:__next()
    if self.ind >= self.vec.length then
        return
    else
        local value = self.vec[self.ind]
        self.ind = self.ind + 1
        return value
    end
end

function vector:__iter()
    return vector_iterator{self}
end

function vector:begin()
    return vector_iterator{self}
end

-- why is end a keyword
function vector:end_()
    return vector_iterator{self, self.length}
end

return {vector = vector}