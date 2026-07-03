print("setting up")
local terminal = require("utils.terminal")

local require_name = true

if fs.exists("/peripheral_names.json") then
    print("Peripheral names list found.")
    require_name = terminal.yes_no("Overwrite? (y/n): ")
end

if require_name then
    local required_peripheral = {
        monitor = {str = "Monitor", type = "monitor"},
        input_inv = {str = "Input inventory", type = "inventory"},
        output_inv = {str = "Output inventory", type = "inventory"},
        packager = {str = "Packager", type = "Create_Packager"},
        frogport = {str = "Frogport", type = "packageport"},
    }

    local names = {}

    for k, v in pairs(required_peripheral) do
        while true do
            write(v.str .. " name: ")
            names[k] = read()
            if not peripheral.isPresent(names[k]) then
                print("Peripheral not found")
                goto continue
            end
            if not peripheral.hasType(names[k], v.type) then
                print("Incorrect peripheral type: " .. textutils.serialise(peripheral.getType(names[k]), { compact = true }))
                goto continue
            end
            do break end
            ::continue::
        end
    end

    local file = fs.open("/peripheral_names.json", "w")
    file.write(textutils.serialize(names))
    file.close()
end

local config_address = true

if fs.exists("/this_address.txt") then
    print("Address for current house found: ")
    local file = fs.open("/this_address.txt", "r")
    print(file.readAll())
    file.close()
    config_address = terminal.yes_no("Overwrite? (y/n): ")
end

if config_address then
    write("Current name: ")
    local name = read()

    local file = fs.open("/this_address.txt", "w")
    file.write(name)
    file.close()
end

print("done")