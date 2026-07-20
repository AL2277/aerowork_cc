package.path = package.path .. ";/package/?.lua;/package/std/?.lua"
local std = {
    __included = {}
}

function std.include(file)
    if not std.__included[file] then
        std.__included[file] = true
        for k, v in pairs(require(file)) do
            std[k] = v
        end
    end
end

std.include("basic")

return std