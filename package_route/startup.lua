local file = fs.open("/peripheral_names.json", "r")
local peripheral_names = textutils.unserialize(file.readAll())
file.close()

local monitor = peripheral.wrap(peripheral_names.monitor)
if not peripheral.hasType(monitor, "monitor") then
    error("Fail to access monitor, unable to alert.")
end

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

local file = fs.open("this_address.json", "r")
local this_address = textutils.unserializeJSON(file.readAll())
file.close()

local this_station = this_address.station
local this_house = this_address.house
