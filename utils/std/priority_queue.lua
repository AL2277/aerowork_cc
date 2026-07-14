local std = require("std")

std.include("class")
std.include("vector")

-- unlike cpp implementation, std::less as comp will result in a min priority queue
local priority_queue = std.class:new("priority_queue")

local function push_top(arr, i, comp)
    while i < arr.length do
        if i*2 + 2 < arr.length and comp(arr[i*2+2], arr[i*2+1])then
            if comp(arr[i*2+2], arr[i]) then
                arr:swap(i, i*2+2)
                i = i*2 + 2
            else
                return
            end
        elseif i*2 + 1 < arr.length then
            if comp(arr[i*2+1], arr[i]) then
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

function priority_queue:priority_queue(arg)
    local arr = arg.arr or arg[1]
    local comp = arg.comp or std.less

    local obj = {comp = comp}
    if std.is_iterable(arr) then
        obj.heap = std.vector{arr}
        for i=obj.heap.length-1,0,-1 do
            push_top(obj.heap, i, comp)
        end
    else
        obj.heap = std.vector{}
    end
    print(std.vector{arr})
    print(obj.heap)
    return obj
end

function priority_queue:empty()
    return self.heap.length == 0
end

function priority_queue:push(v)
    local i = self.heap.length
    self.heap:push_back(v)
    while i > 0 do
        local j=math.floor((i-1)/2)
        if self.comp(self.heap[i], self.heap[j]) then
            self.heap:swap(i, j)
            i = j
        else
            return
        end
    end
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
    local value = self.heap[0]
    -- can't just assign after pop since if heap has only one element, that doesn't empty it
    self.heap[0] = self.heap[self.heap.length - 1]
    self.heap:pop_back()
    push_top(self.heap, 0, self.comp)
    return value
end

function priority_queue:__get(name)
    if name == "length" then
        return self.heap.length;
    end
end

return {priority_queue = priority_queue}