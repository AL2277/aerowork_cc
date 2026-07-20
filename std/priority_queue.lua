local std = require("std")

std.include("class")
std.include("vector")

-- -- unlike cpp implementation, std::less as comp will result in a min priority queue
-- On second thought, it is back to max
local priority_queue = std.class:new("priority_queue")

local function push_top(arg)
    local arr = arg.arr or arg[1]
    local i = arg.i or arg[2] or 0
    local comp = arg.comp or arg[3] or std.less
    local length = arg.length or arg[4] or arr.length
    while i < length do
        if i*2 + 2 < length and comp(arr[i*2+1], arr[i*2+2]) then
            if comp(arr[i], arr[i*2+2]) then
                arr:swap(i, i*2+2)
                i = i*2 + 2
            else
                return
            end
        elseif i*2 + 1 < length then
            if comp(arr[i], arr[i*2+1]) then
                arr:swap(i, i*2+1)
                i = i*2 + 1
            else
                return
            end
        else
            return
        end
    end
end

local function make_heap(arg)
    local arr = arg.arr or arg[1]
    local comp = arg.comp or arg[2] or std.less
    local length = arg.length or arg[3] or arr.length
    for i=length-1,0,-1 do
        push_top{arr, i, comp}
    end
end

local function push_heap(arg)
    -- Assume the element to push is the last element of array if length is not given
    -- Or arr[length] if given
    local arr = arg.arr or arg[1]
    local comp = arg.comp or arg[2] or std.less
    local length = arg.length or arg[3] or arr.length - 1
    local i = length
    while i > 0 do
        local j=math.floor((i-1)/2)
        if comp(arr[j], arr[i]) then
            arr:swap(i, j)
            i = j
        else
            return
        end
    end
end

local function pop_heap(arg)
    local arr = arg.arr or arg[1]
    local comp = arg.comp or arg[2] or std.less
    local length = arg.length or arg[3] or arr.length
    arr:swap(0, length-1)
    push_top{arr, 0, comp, length-1}
end

function priority_queue:priority_queue(arg)
    local arr = arg.arr or arg[1]
    local comp = arg.comp or std.less

    local obj = {comp = comp}
    if std.is_iterable(arr) then
        obj.heap = std.vector{arr}
        make_heap{obj.heap, comp}
    else
        obj.heap = std.vector{}
    end
    return obj
end

function priority_queue:empty()
    return self.heap.length == 0
end

function priority_queue:push(v)
    self.heap:push_back(v)
    push_heap{self.heap, self.comp}
end

function priority_queue:top()
    if self.heap.length == 0 then
        error("Queue is empty")
    end
    return self.heap[0]
end

function priority_queue:pop()
    if self.heap.length == 0 then
        error("Queue is empty")
    end
    pop_heap{self.heap, self.comp}
    return self.heap:pop_back()
end

function priority_queue:__get(name)
    if name == "length" then
        return self.heap.length;
    end
end

return {priority_queue = priority_queue, make_heap = make_heap, push_heap = push_heap, pop_heap = pop_heap}