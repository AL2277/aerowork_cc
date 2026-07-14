local std = require("std")

std.include("vector")
std.include("priority_queue")

-- TEST_VECTOR = true
TEST_VECTOR = false
TEST_HEAP = true
-- TEST_HEAP = false

if TEST_VECTOR then
    local a = std.vector{}
    local b = std.vector{{1,2}}
    print(a, "\texp: []")
    print(b, "\texp: [1, 2]")

    a:push_back(3)
    b:push_back(4)
    print(a, "\texp: [3]")
    print(b, "\texp: [1, 2, 4]")

    for i in std.iter(b) do write(i, " ") end
    print("\texp: 1 2 4")

    b:pop_back(4)

    print(b, "\texp: [1, 2]")
    print(b[1], "\texp: 2")
    b[0] = 9
    print(b, "\texp: [9, 2]")

    local c = b
    print(b, "\texp: [9, 2]")
    print(c, "\texp: [9, 2]")
    b[0] = 7
    print(b, "\texp: [7, 2]")
    print(c, "\texp: [7, 2]")

    local d = std.vector{b}
    print(b, "\texp: [7, 2]")
    print(d, "\texp: [7, 2]")
    b[0] = 70
    print(b, "\texp: [70, 2]")
    print(d, "\texp: [7, 2]")

    local e = std.vector{5}
    print(e, "\texp: [0, 0, 0, 0, 0]")
end

if TEST_HEAP then
    local a = std.priority_queue{{1,9,2,4,7}}
    print(a.heap)
    print(a:pop())
    print(a:pop())
    a:push(5)
    a:push(8)
    a:push(3)
    print(a.heap)
    print(a:pop())
    print(a:pop())
    print(a:pop())
    print(a:pop())
    print(a:pop())
    print(a.heap)
    print(a:pop())
    print(a.heap)
end