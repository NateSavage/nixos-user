--- Language server for C#
--- can be installed with Mason: csharp-language-server

---@type vim.lsp.Config
return {
    cmd = { 'csharp-ls' },
    filetypes = { 'cs', 'csproj' },
    root_markers = { '.git' },
    init_options = {
        AutomaticWorkspaceInit = true,
    },
}
