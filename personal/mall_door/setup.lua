package.path = package.path .. ";/packages/?.lua"
local terminal = require("utils.terminal")

print("setting up")

local require_name = true

if fs.exists("/peripheral_names.json") then
    print("Peripheral names list found.")
    require_name = terminal.yes_no("Overwrite? (y/n): ")
end

if require_name then
    local file = fs.open("/peripheral_names.json", "w")
    file.write(textutils.serialize({
        gearshift = "redstone_relay_x",
        clutch = "redstone_relay_x",
        bearing = "Create_MechanicalBearing_x",
        player = "player_detector_x",
    }))
    file.close()
end