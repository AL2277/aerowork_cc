package.path = package.path .. ";/packages"

local rot = peripheral.find("Create_SequencedGearshift")
local gearshift = peripheral.find("redstone_relay_x")
local gearshift = peripheral.find("redstone_relay_x")

assert(rot ~= nil)

function r(x)local s;if x>0 then g.setOutput("bottom", false) else g.setOutput("bottom", true) end; c.setOutput("bottom", true);sleep(math.abs(x)*0.05);c.setOutput("bottom", false)end

-- assume inital state is closed

local stack = {}

local function open()
    if (#stack) % 2 == 1 then
        return
    end

end