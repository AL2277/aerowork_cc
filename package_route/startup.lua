local file = fs.open("/peripheral_names.json", "r")
local peripheral_names = textutils.unserialize(file.readAll())
file.close()

local monitor = peripheral.wrap(peripheral_names.monitor)
if not peripheral.hasType(monitor, "monitor") then
    error("Fail to access monitor, unable to alert.")
end

local monitor_width, monitor_height = monitor.getSize()

monitor.setBackgroundColor(colors.black)
monitor.clear()

local function alert_error_init()
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.red)
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("An error has occurred")
    monitor.setCursorPos(1, 2)
    monitor.write("Please contract AlbertLin2288")
    monitor.setCursorPos(1, 4)
end

local function alert_missing(name)
    alert_error_init()
    monitor.write("Error: Missing peripheral: " .. name)
    error("Missing peripheral: " .. name)
end

if not peripheral.hasType(peripheral_names.input_inv, "inventory") then alert_missing("Input inventory") end
if not peripheral.hasType(peripheral_names.output_inv, "inventory") then alert_missing("Output inventory") end
if not peripheral.hasType(peripheral_names.packager, "Create_Packager") then alert_missing("Packager") end
if not peripheral.hasType(peripheral_names.frogport, "packageport") then alert_missing("Frogport") end
local input_inv = peripheral.wrap(peripheral_names.input_inv)
local output_inv = peripheral.wrap(peripheral_names.output_inv)
local packager = peripheral.wrap(peripheral_names.packager)
local frogport = peripheral.wrap(peripheral_names.frogport)


local request, err, code = http.get("https://raw.githubusercontent.com/AL2277/aerowork_cc/master/package_route/address_book.json")

if request == nil then
    alert_error_init()
    monitor.write("Error: failed to access address book")
    print("error: " .. err)
    print("code: " .. code)
    error("Failed to access address book")
end

local address_book = textutils.unserializeJSON(request.readAll())

file = fs.open("this_address.txt", "r")
local this_name = file.readAll()
file.close()

if address_book[this_name] == nil then
    alert_error_init()
    monitor.write("Incorrect configuration for current address")
    error("Current name not in address book")
end

local this_station = address_book[this_name].station
local this_house = address_book[this_name].house

local name_list = {}

for name, _ in pairs(address_book) do
    name_list[#name_list+1] = name
end

local TABSIZE = 16
local COLUMNS = 5

local selected = 0

local function display_names()
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    for i=0,(#name_list-1) do
        if i == selected then
            monitor.setBackgroundColor(colors.white)
            monitor.setTextColor(colors.black)
        end
        monitor.setCursorPos(TABSIZE * (i % COLUMNS) + 1, math.floor(i / COLUMNS)*3 + 1)
        monitor.write(string.rep(" ", #name_list[i+1] + 2))
        monitor.setCursorPos(TABSIZE * (i % COLUMNS) + 1, math.floor(i / COLUMNS)*3 + 2)
        monitor.write(" " .. name_list[i+1] .. " ")
        monitor.setCursorPos(TABSIZE * (i % COLUMNS) + 1, math.floor(i / COLUMNS)*3 + 3)
        monitor.write(string.rep(" ", #name_list[i+1] + 2))
        if i == selected then
            monitor.setBackgroundColor(colors.black)
            monitor.setTextColor(colors.white)
        end
        -- monitor.write(TABSIZE - #(name_list[i+1]))
    end
end

local function send_package_to_address(station, house)
    for slot, _ in pairs(input_inv.list()) do
        input_inv.pushItems(peripheral.getName(output_inv), slot)
    end

    local source_station = this_station
    if source_station == station then
        source_station = "same"
    end

    packager.setAddress("post-" .. source_station .. "-" .. station .. "-" .. house)

    while next(output_inv.list()) ~= nil do
        packager.makePackage()
        sleep(0.1)
    end
end

local function send_package_to_name(name)
    if address_book[name] == nil then
        alert_error_init()
        error("name not in address book")
    end
    send_package_to_address(address_book[name].station, address_book[name].house)
end

while true do
    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    display_names()

    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.black)
    monitor.setCursorPos(1, monitor_height-2)
    monitor.write("        ")
    monitor.setCursorPos(1, monitor_height-1)
    monitor.write("  Send  ")
    monitor.setCursorPos(1, monitor_height)
    monitor.write("        ")

    local event, _, x, y = os.pullEvent("monitor_touch")

    if x <= 8 and y >= monitor_height-2 then
        monitor.setBackgroundColor(colors.black)
        monitor.setTextColor(colors.black)
        monitor.clear()
        local msg = "Sending..."
        monitor.setCursorPos(math.ceil((monitor_width - #msg)/2), math.ceil(monitor_height/2))
        monitor.write(msg)
        send_package_to_name(name_list[selected+1])
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
    else
        local click_index = math.floor((x-1) / TABSIZE) + math.floor((y-1) / 3) * COLUMNS
        if click_index < #name_list + 2 then
            if (x-1) % TABSIZE < #(name_list[click_index+1]) then
                selected = click_index
            end
        end
    end
end
