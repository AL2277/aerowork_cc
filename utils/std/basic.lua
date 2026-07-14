local function less(a, b)
    return a<b
end

local function greater(a, b)
    return a>b
end

return {less = less, greater = greater}