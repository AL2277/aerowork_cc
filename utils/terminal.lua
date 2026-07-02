
local function yes_no(prompt, err_msg, first_prompt)
    if err_msg == nil then
        err_msg = "Invalid choice\n"
    end
    if first_prompt == nil then
        first_prompt = prompt
    end
    write(first_prompt)
    while true do
        local ans = read()
        if ans == "y" then
            return true
        elseif ans == "n" then
            return false
        end
        write(err_msg)
        write(prompt)
    end
end

return {
    yes_no = yes_no
}