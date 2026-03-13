---@class savage.Highlight: vim.api.keyset.highlight
---@field style? vim.api.keyset.highlight

---@alias savage.Highlights table<string,savage.Highlight|string>

---@alias savage.HighlightsFn fun(colors: ColorScheme, opts:savage.Config):savage.Highlights

---@class savage.Cache
---@field groups savage.Highlights
---@field inputs table
