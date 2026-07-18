package.path = package.path .. ";/package/?.lua"

local file = fs.open("/peripheral_names.json", "r")
local peripheral_names = textutils.unserialize(file.readAll())
file.close()


local gearshift = peripheral.wrap(peripheral_names.gearshift)
local clutch = peripheral.wrap(peripheral_names.clutch)
local bearing = peripheral.wrap(peripheral_names.bearing)
local player = peripheral.wrap(peripheral_names.player)

-- 0: open
-- 1: close
-- the correct state to be in
local state = 0

TOL = 1

parallel.waitForAny(
    (function ()
        while true do
            if player.isPlayersInRange(10) then
                state = 0
            else
                state = 1
            end
            os.sleep(0.05)
        end
    end),
    (function ()
        while true do
            clutch.setOutput("bottom", false)
            local angle = bearing.getAngle()
            if (state == 1 and angle < 51 - TOL) then
                gearshift.setOutput("bottom", true)
                clutch.setOutput("bottom", true)
            elseif (state == 0 and angle > 0 + TOL) then
                gearshift.setOutput("bottom", false)
                clutch.setOutput("bottom", true)
            end
            os.sleep(0.05)
        end
    end)
)

-- g=peripheral.wrap("redstone_relay_4");c=peripheral.wrap("redstone_relay_5");b=peripheral.wrap("Create_MechanicalBearing_1")
-- function r(x)sleep(0.05);if x>0 then g.setOutput("bottom", false) else g.setOutput("bottom", true) end; c.setOutput("bottom", true);sleep(math.abs(x)*0.05);c.setOutput("bottom", false)end


-- function open() g.setOutput("bottom", false);c.setOutput("bottom", true);while math.abs(b.getAngle()-0)>0.1 do os.sleep(0.05) end c.setOutput("bottom",false) end
-- function close() g.setOutput("bottom", true);c.setOutput("bottom", true);while math.abs(b.getAngle()-51)>0.1 do os.sleep(0.05) end c.setOutput("bottom",false) end
-- g.setOutput("bottom", true);c.setOutput("bottom", true);sleep(0.1);c.setOutput("bottom", false)

-- -- assume inital state is closed

-- local function time()
--     return os.epoch() / 3600
-- end

-- local function comp(a, b)
--     return a.time < b.time
-- end

-- local events = std.priority_queue{comp = comp}

-- while true do
--     local cur_time = time()
--     while events:top().time == time do
--         -- process events
--     end
--     sleep(0)
-- end
