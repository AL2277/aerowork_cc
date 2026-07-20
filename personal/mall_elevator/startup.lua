package.path = package.path .. ";/package/?.lua;;/package/?/init.lua;/package/?/?.lua"
local std = require("std")

std.include("class")
std.include("container")
std.include("vector")
std.include("algorithm")

local file = fs.open("/config.json", "r")
local config = textutils.unserialize(file.readAll())
file.close()

local function time()
    return os.epoch() / 3600
end

local player = peripheral.find("player_detector") -- this time, location doesn't matter
local link = peripheral.find("redstone_link_bridge")

local elevators = {}
local floors = std.vector{};

local Elevator = std.class:new("Elevator")
function Elevator:Elevator(arg)
    local elevator = arg.elevator or arg[1]
    local obj = {
        occupied = false,
        called = false,
        cooldown = 0, -- time till aviliable for calling
        target_offset = elevator.target_offset, -- getCurrentTargetY() - getCurrentY() when stoped
        cabin_pos = {
            corner1 = elevator.cabin_pos.corner1,
            corner2 = elevator.cabin_pos.corner2,
        },
        floor_indicators = {},
        peripheral = peripheral.wrap(elevator.peripheral)
    }
    for i, name in ipairs(elevator.floor_indicators) do
        obj.floor_indicators[i] = peripheral.wrap(name)
    end
    return obj
end

function Elevator:offset_pos(arg)
    local pos = arg.pos or arg[1]
    return {x = pos.x, y = pos.y + self.target_offset, z = pos.z}
end

function Elevator:update_arrive()
    local y = self.peripheral.getCurrentFloor()
    if y ~= nil then
        local floor = floors[std.lower_bound(floors, y)]
        if floor == nil then print("invalid floor"); return end
        if self.occupied or self.called then
            self.cooldown = time() + 20 * 5 -- 5 seconds
        end
        floor:arrived()
        -- fair to assume no one hijacked the elevator, so it must arrived at called floor
        self.called = false
    end
end

function Elevator:is_callable()
    return (not self.occupied) and (not self.called) and (self.cooldown < time())
end

function Elevator:update_occupied()
    self.occupied = player.isPlayersInCoord(
        self:offset_pos(self.cabin_pos.corner1),
        self:offset_pos(self.cabin_pos.corner2)
    )
end

function Elevator:set_floor_indicators(arg)
    local floor = arg.floor or arg[1]
    for _, peri in ipairs(self.floor_indicators) do
        peri.clear()
        local _, w = peri.getSize()
        peri.setCursorPos(w - (#floor) + 1, 1)
        peri.write(floor)
    end
end


for i, elevator in ipairs(config.elevators) do
    elevators[i] = Elevator{elevator}
end

local Floor = std.class:new("Floor")

function Floor:Floor(arg)
    local floor = arg.floor or arg[1]
    local obj = {
        name = floor.name,
        call = floor.call,
        indicator = floor. indicator,
        y = floor. y,
        called = false,
        answered = false,
        cooldown = 0, -- cooldown until being able to be called again
        expire = 0, -- if the call isn't able to be answered for a long time, it will be reseted
    }
    link.sendLinkSignal(self.indicator.freq1, self.indicator.freq2, 0)
    return obj
end

function Floor:update_call()
    local called = false
    if self.cooldown < time() then
        called = link.getLinkSignal(self.call.freq1, self.call.freq2) ~= 0
    end
    if called then
        self.called = true
        self.cooldown = time() + 20 * 4 -- 4 seconds
        self.expire = time() + 20 * 60 * 3 -- 3 minutes
    else
        if self.expire > time() and not self.answered then
            self.called = false
        end
    end
    if self.called then
        link.sendLinkSignal(self.indicator.freq1, self.indicator.freq2, 15)
    else
        link.sendLinkSignal(self.indicator.freq1, self.indicator.freq2, 0)
    end
end

function Floor:arrived()
    self.cooldown = time() + time() + 20 * 4 -- 4 seconds
    self.called = false
    self.answered = false
    link.sendLinkSignal(self.indicator.freq1, self.indicator.freq2, 0)
end

function Floor.__lt(a, b)
    if type(a) == "table" and a.__cls == "Floor" then a = a.y end
    if type(b) == "table" and b.__cls == "Floor" then b = b.y end
    return a < b
end

function Floor.__gt(a, b)
    if type(a) == "table" and a.__cls == "Floor" then a = a.y end
    if type(b) == "table" and b.__cls == "Floor" then b = b.y end
    return a > b
end

for _,floor in ipairs(config.floors) do
    floors.push_back(Floor{floor})
end
std.sort(floors)


parallel.waitForAny(
    (function ()
        while true do
            for _, elevator in ipairs(elevators) do
                elevator:update_occupied()
            end
            os.sleep(0.05)
        end
    end),
    (function ()
        while true do
            for floor in std.iter(floors) do
                floor:update_call()
            end
            for _, elevator in ipairs(elevators) do
                elevator:update_arrive()
                if elevator:is_callable() then
                    for floor in std.iter(floors) do
                        if floor.called and not floor.answered then
                            elevator.peripheral.setTargetFloor(floor.y)
                            elevator.called = true
                            floor.answered = true
                        end
                    end
                end
            end
            os.sleep(0.05)
        end
    end)
)

