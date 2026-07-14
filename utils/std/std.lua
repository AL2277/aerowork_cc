local std = {
    __included = {}
}

function std.include(file)
    if not std.__included[file] then
        for k, v in pairs(require(file)) do
            std[k] = v
        end
    end
end

std.include("basic")

return std