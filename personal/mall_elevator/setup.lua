package.path = package.path .. ";/package/?.lua"
local terminal = require("utils.terminal")

print("setting up")

local default_config =
{
    elevators = {
        {
            peripheral = "Create_ElevatorPulley_1",
            target_offset = 123, -- getCurrentTargetY() - getCurrentY() when stoped
            cabin_pos = { -- x and z are absoulte, y is relative to getCurrentY()
                corner1 = {x =  7, y = -5, z = 487},
                corner2 = {x =  9, y =  0, z = 489},
            },
            floor_indicators = {
                -- "Create_DisplayLink_x",
                -- "Create_DisplayLink_x",
            },
        },
        {
            peripheral = "Create_ElevatorPulley_0",
            target_offset = 123,
            cabin_pos = {
                corner1 = {x = 10, y = -5, z = 487},
                corner2 = {x = 12, y =  0, z = 489},
            },
            floor_indicators = {
                -- "Create_DisplayLink_x",
                -- "Create_DisplayLink_x",
            },
        },
    },
    floors = {
        {
            name = "0",
            call = {
                freq1 = "create:elevator_pulley",
                freq2 = "betterblockz:lablink_blockz_0",
            },
            indicator = {
                freq1 = "minecraft:redstone_lamp",
                freq2 = "betterblockz:lablink_blockz_0",
            },
            y = 205,
        },
        {
            name = "1",
            call = {
                freq1 = "create:elevator_pulley",
                freq2 = "betterblockz:lablink_blockz_1",
            },
            indicator = {
                freq1 = "minecraft:redstone_lamp",
                freq2 = "betterblockz:lablink_blockz_1",
            },
            y = 213,
        },
        {
            name = "2",
            call = {
                freq1 = "create:elevator_pulley",
                freq2 = "betterblockz:lablink_blockz_2",
            },
            indicator = {
                freq1 = "minecraft:redstone_lamp",
                freq2 = "betterblockz:lablink_blockz_2",
            },
            y = 219,
        },
        {
            name = "3",
            call = {
                freq1 = "create:elevator_pulley",
                freq2 = "betterblockz:lablink_blockz_3",
            },
            indicator = {
                freq1 = "minecraft:redstone_lamp",
                freq2 = "betterblockz:lablink_blockz_3",
            },
            y = 224,
        },
        {
            name = "4",
            call = {
                freq1 = "create:elevator_pulley",
                freq2 = "betterblockz:lablink_blockz_4",
            },
            indicator = {
                freq1 = "minecraft:redstone_lamp",
                freq2 = "betterblockz:lablink_blockz_4",
            },
            y = 229,
        },
        {
            name = "5",
            call = {
                freq1 = "create:elevator_pulley",
                freq2 = "betterblockz:lablink_blockz_5",
            },
            indicator = {
                freq1 = "minecraft:redstone_lamp",
                freq2 = "betterblockz:lablink_blockz_5",
            },
            y = 234,
        },
        {
            name = "6",
            call = {
                freq1 = "create:elevator_pulley",
                freq2 = "betterblockz:lablink_blockz_6",
            },
            indicator = {
                freq1 = "minecraft:redstone_lamp",
                freq2 = "betterblockz:lablink_blockz_6",
            },
            y = 239,
        },
        {
            name = "7",
            call = {
                freq1 = "create:elevator_pulley",
                freq2 = "betterblockz:lablink_blockz_7",
            },
            indicator = {
                freq1 = "minecraft:redstone_lamp",
                freq2 = "betterblockz:lablink_blockz_7",
            },
            y = 244,
        },
    },
}


local require_name = true

if fs.exists("/config.json") then
    print("Config found.")
    require_name = terminal.yes_no("Overwrite? (y/n): ")
end

if require_name then
    local file = fs.open("/config.json", "w")
    file.write(textutils.serialize(default_config))
    file.close()
end