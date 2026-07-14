local std = require("std")
std.include("class")


local array_iterator = std.class("array_iterator")
function array_iterator:array_iterator(arg)
    local arr = arg.arr or arg[1]
    local ind = arg.ind or arg[2] or 0

    local obj = {arr = arr, ind = ind}

    return obj
end

function array_iterator:__next()
    self.ind = self.ind + 1
    return self.arr[self.ind]
end

local function next(obj)
    return obj:__next()
end

local function is_iterable(obj)
    if type(obj) == "table" then
        if obj.__cls then
            return obj.__iter ~= nil
        else
            return true
        end
    else
        return false
    end
end

local function iter(obj)
    if not is_iterable(obj) then
        error("Object of class " .. std.my_type(obj) .. " is not iterable")
    end
    if type(obj) == "table" then
        if obj.__cls ~= nil then
            -- type is object
            return next, obj:__iter()
        elseif obj[1] ~= nil then
            -- rough check for array
            return next, array_iterator{obj}
        else
            -- generic table
            return pairs(obj)
        end
    end
end

return {next = next, is_iterable = is_iterable, iter = iter}