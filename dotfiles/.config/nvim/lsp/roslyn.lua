--- Language server for C#
--- can be installed with 'dotnet tool install --global csharp-ls'

-- searches upward from the given directory until a .sln file is found or the top level directory is reached
-- returns nil if no .sln file is found
local function find_solution_file(from_dir)
    local start_dir = from_dir or vim.fn.getcwd()
    local current_dir = start_dir
    while true do
        -- Get the list of files in the current directory
        local matches = vim.fn.glob(current_dir .. '/*.sln')

        -- Check if any .sln files were found
        if matches ~= '' then
            local count = #matches
            if count > 1 then
             --   vim.notify("roslyn.lua: found "..count.." solution files... \n"..matches)
                matches = matches:match("([^\n]+)") --take only the first file
            end
             -- Get the relative path from the current working directory
            local relative_path = vim.fn.fnamemodify(matches, ':.')
            --vim.notify("solution file: " .. relative_path)
            return relative_path  -- Return the relative path of the found .sln file
        end

        -- Move up one directory
        local parent_dir = current_dir:match("^(.*)[/\\]")
        if not parent_dir then
            break  -- Exit if there's no parent directory
        end
        current_dir = parent_dir
        --vim.notify("checking "..current_dir)
    end
    vim.notify("roslyn.lua: no solution file found searching from directory: "..start_dir)
    return nil  -- Return nil if no .sln file was found
end

local function get_cmd()
   local solution_filepath = find_solution_file(vim.fn.getcwd())
    if solution_filepath then
        return { 'csharp-ls', '--solution', solution_filepath, '--debug' }
    else
        return { 'csharp-ls' }
    end
end

---@type vim.lsp.Config
return {
  cmd = get_cmd(),
  filetypes = { 'cs' },
--  root_markers = { '.sln', '.csproj', '.git' },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
}
