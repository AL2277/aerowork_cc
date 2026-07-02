print("setting up")

local require_name = true

if fs.exists("/peripheral_names.txt") then
    print("Peripheral names list found.")
    write("Overwrite? (y/n): ")
    while true do
        local ans = read()
        if ans == "y" then
            break
        elseif ans == "n" then
            require_name = false
            break
        end
        print("Invalid choice")
        write("Overwrite? (y/n): ")
    end

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
            if peripheral.isPresent(names[k]) == nil then
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

    local file = fs.open("/peripheral_names.txt", "w")
    file.write(textutils.serialize(names))
    file.close()
end


print("done")