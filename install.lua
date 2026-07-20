VERSION_MAJOR = 1
VERSION_MINOR = 0
VERSION_PATCH = 11

VERSION = string.format("%s.%s.%s", VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH)

package.path = package.path .. ";/package/?.lua"
local argv = {...}
local argc = #argv

local request, err, code = http.get("https://raw.githubusercontent.com/AL2277/aerowork_cc/master/program_list.json")

if request == nil then
    print("failed to access program list")
    print("error: " .. err)
    print("code: " .. code)
    return
end

local data = textutils.unserializeJSON(request.readAll())

if data.installer_version ~= VERSION then
    while true do
        write("Installer outdated, update installer?")
        local ans = read()
        if ans == "y" then
            fs.delete("/install")
            shell.run("wget https://raw.githubusercontent.com/AL2277/aerowork_cc/master/install.lua install")
            shell.run("install", ...)
            break
        elseif ans == "n" then
            break
        end
        write("invalid choice")
    end
end

local installed_package = {}

local function install(program, path, force)
    force = force or 0

    print("Installing program " .. program)

    if data[program] == nil then
        error("Unknown program: " .. program)
    end

    print("Gathering program info")

    local setup_info = textutils.unserializeJSON(http.get(data[program]).readAll())

    local version = setup_info.version

    local version_path = fs.combine(path, "version_" .. program .. ".txt")
    if fs.exists(version_path) then
        local file = fs.open(version_path, "r")
        local version_cur = file.readAll()
        file.close()
        print("Found existing version: " .. version_cur)
        if force == 0 and version_cur == version then
            print("Already up to date")
            return
        elseif force ~= 0 then
            print("Force reinstalling")
        else
            print("Updating to version: " .. version)
        end
    else
        print("Installing version: " .. version)
    end

    local file = fs.open(version_path, "w")
    file.write(version)
    file.close()

    print("Installing dependency")

    for _, dep in ipairs(setup_info.dependency) do
        if not installed_package[dep] then
            if force == 2 then
                install(dep, "/package", 2)
            else
                install(dep, "/package", 0)
            end
        end
    end

    print("Downloading files")

    for fn, url in pairs(setup_info.files) do
        local file = fs.open(fs.combine(path, fn), "w")
        file.write(http.get(url).readAll())
        file.close()
    end

    print("Setting up")

    if setup_info.setup ~= nil then
        local file = fs.open(fs.combine(path, "/setup.lua"), "w")
        file.write(http.get(setup_info.setup).readAll())
        file.close()
        shell.run(fs.combine(path, "setup"))
    end

    print("Finished installing program: " .. program)

    installed_package[program] = true
end

if argc >= 1 then
    local program = argv[1]

    if data[program] == nil then
        print("Unknown program: " .. program)
        return
    end

    local force = 0
    if argc >= 2 then
        if string.sub(argv[2], 1, 1) == "-" then
            if string.find(argv[2], "f") then
                force = 1
                if string.find(argv[2], "r") then
                    force = 2
                end
            end
        end
    end

    install(program, "/", force)

else
    print("Error: Missing name")
end