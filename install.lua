local argv = {...}
local argc = #argv

if argc >= 1 then
    local program = argv[1]

    local request, err, code = http.get("https://raw.githubusercontent.com/AL2277/aerowork_cc/master/program_list.json")

    if request == nil then
        print("failed to access program list")
        print("error: " .. err)
        print("code: " .. code)
        return
    end

    local data = textutils.unserializeJSON(request.readAll())

    if data[program] == nil then
        print("Unknown program: " .. program)
        return
    end

    local setup_info = textutils.unserializeJSON(http.get(data[program]).readAll())

    for fn, url in pairs(setup_info.files) do
        local file = fs.open(fn, "w")
        file.write(http.get(url).readAll())
        file.close()
    end

    if setup_info.setup ~= nil then
        shell.run("wget", "run", setup_info.setup)
    end

else
    print("Error: Missing name")
end