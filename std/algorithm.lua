local std = require("std")

std.include("container")
std.include("priority_queue")

local function sort(arg)
    -- Implement heapsort cuz I already have heap implemented
    -- Also only work for vector for now
    -- Sorry about laziness

    local arr = arg.arr or arg[1]
    local comp = arg.comp or arg[2] or std.less

    std.make_heap{arr, comp}
    for l=arr.length,0,-1 do
        std.pop_heap{arr, comp, l}
    end
end

local function lower_bound(arg)
    -- same as cpp lower_bound
    local arr = arg.arr or arg[1]
    local v = arg.v or arg[2]
    local comp = arg.comp or arg[3] or std.less

    local l, r = 0, arr.length
    if arr.length and (not comp(arr[0], v)) then return 0 end
    while l+1 < r do
        local m = math.floor((l+r)/2)
        if comp(arr[m], v) then
            l = m
        else
            r = m
        end
    end
    return r
end

local function upper_bound(arg)
    -- same as cpp upper_bound
    local arr = arg.arr or arg[1]
    local v = arg.v or arg[2]
    local comp = arg.comp or arg[3] or std.less

    local l, r = 0, arr.length
    if arr.length and comp(v, arr[0]) then return 0 end
    while l+1 < r do
        local m = math.floor((l+r)/2)
        if comp(v, arr[m]) then
            r = m
        else
            l = m
        end
    end
    return r
end

return {sort = sort, lower_bound = lower_bound, upper_bound = upper_bound}