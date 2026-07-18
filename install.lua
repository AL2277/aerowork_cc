VERSION_MAJOR = 1
VERSION_MINOR = 0
VERSION_PATCH = 5

VERSION = string.format("%s.%s.%s", VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH)

package.path = package.path .. ";/packages/?.lua"
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
            shell.rm("install")
            shell.run("wget https://raw.githubusercontent.com/AL2277/aerowork_cc/master/install.lua install")
            shell.run("install", ...)
            return
        elseif ans == "n" then
            break
        end
        write("invalid choice")
    end
end

local installed_package = {}

local function install(program, path)
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
        if version_cur == version then
            print("Already up to date")
            return
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
            install(dep, "/package")
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

    install(program, "/")

else
    print("Error: Missing name")
end