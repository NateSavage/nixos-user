--
-- this file binds our colors to highlight groups defined in neovim and it's plugins

local c = require("theme-savage.colors")
local config = require("theme-savage.config")

local M = {}

M.base = {
    -- base links in neovim 0.11
    ["@attribute"]                         = { fg = c.Type },
    ["@comment"]                           = { fg = c.Comment },
    ["@constant"]                          = { fg = c.Value },
    ["@constant.macro"]                    = { fg = c.Function },
    ["@function"]                          = { fg = c.Function },
    ["@function.method"]                   = { fg = c.Function },
    ["@keyword"]                           = { fg = c.KeyWord },
    ["@module"]                            = { fg = c.Type },
    ["@number"]                            = { fg = c.Value },
    ["@operator"]                          = { fg = c.Syntax },
    ["@property"]                          = { fg = c.Reference },
    ["@string"]                            = { fg = c.LightOrange },
    ["@string.regexp"]                     = { fg = c.Cyan },
    ["@string.special"]                    = { fg = c.Cyan },
    ["@type"]                              = { fg = c.Type },
    ["@type.definition"]                   = { fg = c.Type },
    ["@type.qualifier"]                    = { fg = c.Type },
    ["@variable"]                          = { fg = c.Reference },
    ["@variable.parameter"]                = { fg = c.Reference },
    Added                                  = { fg = c.Cyan },
    Boolean                                = { fg = c.KeyWord },
    Changed                                = { fg = c.Cyan },
    Character                              = { fg = c.LightOrange },
    Comment                                = { fg = c.Comment },
    Conditional                            = { fg = c.FlowControl },
    Constant                               = { fg = c.Value },
    CurSearch                              = { fg = c.fg },
    Cursor                                 = { fg = c.CursorFG, bg = c.CursorBG },
    Delimiter                              = { fg = c.fg },
    DiagnosticDeprecated                   = { fg = c.fg },
    DiagnosticError                        = { fg = c.Error },
    DiagnosticHint                         = { fg = c.Hint },
    DiagnosticInfo                         = { fg = c.Info },
    DiagnosticOk                           = { fg = c.fg },
    DiagnosticWarn                         = { fg = c.Warning },
    --DiffAdd                 = { fg = c.dark, bg = c.DiffAdd },
    --DiffChange              = { fg = c.dark, bg = c.DiffChange, style = 'underline' },
    --DiffDelete              = { fg = c.dark, bg = c.DiffDelete },
    Directory                              = { fg = c.Syntax },
    Error                                  = { fg = c.Error },
    ErrorMsg                               = { fg = c.Error },
    Float                                  = { fg = c.Red },
    FloatBorder                            = { fg = c.fg, bg = c.bg }, -- used for floating window borders
    FloatTitle                             = { fg = c.Red },
    FoldColumn                             = { fg = c.accent, bg = c.dark },
    Function                               = { fg = c.Function },

    -- base groups without links in neovim 0.11
    --["@diff"]
    --["@lsp"]
    ["@markup.heading.1.delimiter.vimdoc"] = { fg = c.Documentation },
    ["@markup.heading.2.delimiter.vimdoc"] = { fg = c.Documentation },
    ["@markup.italic"]                     = { style = 'italic' },
    -- ["@markup.strikethrough"]
    ["@markup.strong"]                     = { style = 'bold' },
    ["@markup.underline"]                  = { style = 'underline' },
    ColorColumn                            = { bg = c.PanelEdges },
    --ComplMatchIns
    Conceal                                = { fg = c.accent, bg = config.transparent_background and 'NONE' or c.bg },
    CursorColumn                           = { bg = c.dark },
    CursorLine                             = { bg = c.PanelEdges },
    CursorLineNr                           = { fg = c.light_gray, bg = c.PanelEdges, style = 'bold' },
    DiagnosticUnderlineError               = { style = 'underline', underline = { style = "curl" } },
    DiagnosticUnderlineHint                = { style = 'underline', underline = { style = "curl" } },
    DiagnosticUnderlineInfo                = { style = 'underline', underline = { style = "curl" } },
    DiagnosticUnderlineOk                  = { style = 'underline', underline = { style = "curl" } },
    DiagnosticUnderlineWarn                = { style = 'underline', underline = { style = "curl" } },
    --DiffAddedGutter          = { fg = c.green },
    --DiffModifiedGutter       = { fg = c.Value },
    --DiffRemovedGutter        = { fg = c.Error },
    DiffText                               = { fg = c.dark, bg = c.DiffText },
    --FloatShadow
    --FloatShadowThrough
    Folded                                 = { fg = c.accent, bg = c.dark },
    Identifier                             = { fg = c.fg },
    lCursor                                = { fg = c.cursor_fg, bg = c.cursor_bg },
    LineNr                                 = { fg = c.context }, -- line number display on the far left
    -- luaBlock
    -- luaCondElseif
    -- luaCondEnd
    -- luaCondStart
    -- luaFunctionBlock
    -- luaInnerComment
    -- luaParen
    -- luaRepeatBlock
    -- luaTableBlock
    -- luaWhile
    MatchParen                             = { fg = c.Hint, bg = c.bg, style = 'underline' },
    Method                                 = { fg = c.Function },
    ModeMsg                                = { fg = c.fg, bg = c.bg },
    MoreMsg                                = { fg = c.fg, bg = c.bg },
    MsgArea                                = { fg = c.fg, bg = config.transparent_background and 'NONE' or c.bg },
    --[[
  NeoscrollHiddenCursor
  NonText
  Normal
  NormalFloat
  NormalNC
  NvimInternalError
  Operator
  Pmenu
  PmenuMatch
  PmenuMatchSel
  PmenuSel
  PmenuThumb
  PreProc
  Question
  QuickFixLine
  RedrawDebugClear
  RedrawDebugComposed
  RedrawDebugNormal
  RedrawDebugRecompose
  Removed
  Search
  SignColumn
  SignifyLineAdd
  SignifyLineChange
  SignifyLineDelete
  SignifySignAdd
  SignifySignChange
  SignifySignDelete
  SmearCursorHideable
  Special
  SpecialKey
  SpellBad
  SpellCap
  SpellLocal
  SpellRare
  Statement
  StatusLine
  StatusLineNC
  String
  Struct
  TabLineSel
  TermCursor
  Title
  Todo
  Type
  Underlined
  Visual
  VisualNC
  WarningMsg
  WinBar
  WinBarNC
  ]] --

    CursorIM = { fg = c.cursor_fg, bg = c.cursor_bg },
    Debug = { fg = c.Error },
    Define = { fg = c.purple },
    DiffAdded = { fg = c.DiffAdd },
    DiffRemoved = { fg = c.DiffDelete },
    DiffFile = { fg = c.cyan },
    DiffIndexLine = { fg = c.gray },
    EndOfBuffer = { fg = c.bg },
    Exception = { fg = c.Exception },
    Ignore = { fg = c.cyan, bg = c.bg, style = 'bold' },
    IncSearch = { fg = c.light_gray, bg = c.search_blue },
    Include = { fg = c.KeyWord },
    Keyword = { fg = c.KeyWord },
    Label = { fg = c.blue },
    Macro = { fg = c.Function },
    MatchParenCur = { style = 'underline' },
    MatchWord = { style = 'underline' },
    MatchWordCur = { style = 'underline' },
    MsgSeparator = { fg = c.fg, bg = c.bg },
    NonText = { fg = c.fg },
    Normal = { fg = c.fg, bg = config.transparent_background and 'NONE' or c.bg },
    NormalFloat = { bg = c.bg }, -- background of floating windows
    NormalNC = { fg = c.fg, bg = config.transparent_background and 'NONE' or c.bg },
    Number = { fg = c.Value },
    Operator = { fg = c.fg },
    Pmenu = { fg = c.light_gray, bg = c.popup_back },
    PmenuSbar = { bg = c.dark },
    PmenuSel = { fg = c.dark, bg = c.blue },
    PmenuThumb = { bg = c.gray },
    PreCondit = { fg = c.gray },
    PreProc = { fg = c.Documentation }, --preprocessor statements what color for doc comments?
    Question = { fg = c.orange },
    QuickFixLine = { bg = c.dark_gray },
    Repeat = { fg = c.purple },
    Search = { fg = c.light_gray, bg = c.search_blue },
    SignColumn = { bg = c.PanelEdges }, -- gutter on the far left used to display that a ligh has a warning, or change in git
    Special = { fg = c.purple },
    SpecialChar = { fg = c.fg },
    SpecialComment = { fg = c.gray },
    SpecialKey = { fg = c.blue, style = 'bold' },
    SpellBad = { fg = c.Error, style = 'underline' },
    SpellCap = { fg = c.yellow, style = 'underline' },
    SpellLocal = { fg = c.green, style = 'underline' },
    SpellRare = { fg = c.purple, style = 'underline' },
    Statement = { fg = c.purple },
    StatusLine = { fg = c.dark },
    StatusLineNC = { fg = c.dark },
    StatusLineSeparator = { fg = c.dark },
    StatusLineTerm = { fg = c.dark },
    StatusLineTermNC = { fg = c.dark },
    StorageClass = { fg = c.cyan },
    String = { fg = c.LightOrange },
    Structure = { fg = c.Value },
    Substitute = { fg = c.light_gray, bg = c.search_orange },
    TabLine = { fg = c.light_gray, bg = c.dark },
    TabLineFill = { fg = c.fg, bg = c.PanelEdges },
    TabLineSel = { fg = c.fg, bg = c.dark },
    Tag = { fg = c.blue },
    TermCursor = { fg = c.cursor_fg, bg = c.cursor_bg },
    -- TermCursorNC = { fg = c.cursor_fg, bg = c.cursor_bg },
    Title = { fg = c.blue, style = 'bold' },
    Todo = { fg = c.Documentation, bg = c.bg, style = 'bold' },
    Type = { fg = c.Type },
    Typedef = { fg = c.Type },
    --Variable = { fg = c.Reference },
    VertSplit = { fg = c.gray, bg = c.bg },
    WinSeparator = { fg = c.gray, bg = c.bg },
    Visual = { bg = c.ui_blue },
    VisualNOS = { bg = c.dark },
    WarningMsg = { fg = c.Warning, bg = c.bg },
    Whitespace = { fg = c.gray },
    WildMenu = { fg = c.dark, bg = c.blue },
    -- Markdown
    -- markdownBlockquote = { fg = c.accent },
    markdownBold = { fg = c.yellow, style = 'bold' },
    markdownCode = { fg = c.green },
    markdownCodeBlock = { fg = c.green },
    markdownCodeDelimiter = { fg = c.green },
    markdownH1 = { fg = c.blue },
    markdownH2 = { fg = c.blue },
    markdownH3 = { fg = c.blue },
    markdownH4 = { fg = c.blue },
    markdownH5 = { fg = c.blue },
    markdownH6 = { fg = c.blue },
    markdownHeadingDelimiter = { fg = c.blue },
    --  markdownHeadingRule = { fg = c.accent },
    markdownId = { fg = c.purple },
    markdownIdDeclaration = { fg = c.blue },
    markdownIdDelimiter = { fg = c.light_gray },
    markdownItalic = { style = 'italic' },
    markdownLinkDelimiter = { fg = c.light_gray },
    markdownLinkText = { fg = c.blue },
    markdownListMarker = { fg = c.red },
    markdownOrderedListMarker = { fg = c.red },
    --  markdownRule = { fg = c.accent },
    markdownUrl = { fg = c.cyan, style = 'underline' },
}

M.plugins = {
    -- Buffer
    BufferCurrent                        = { fg = c.fg, bg = c.bg },
    BufferCurrentIndex                   = { fg = c.fg, bg = c.bg },
    BufferCurrentMod                     = { fg = c.info_yellow, bg = c.bg },
    BufferCurrentSign                    = { fg = c.hint_blue, bg = c.bg },
    BufferCurrentTarget                  = { fg = c.red, bg = c.bg, style = 'bold' },
    BufferInactive                       = { fg = c.gray, bg = c.dark },
    BufferInactiveIndex                  = { fg = c.gray, bg = c.dark },
    BufferInactiveMod                    = { fg = c.info_yellow, bg = c.dark },
    BufferInactiveSign                   = { fg = c.gray, bg = c.dark },
    BufferInactiveTarget                 = { fg = c.red, bg = c.dark, style = 'bold' },
    BufferVisible                        = { fg = c.fg, bg = c.bg },
    BufferVisibleIndex                   = { fg = c.fg, bg = c.bg },
    BufferVisibleMod                     = { fg = c.info_yellow, bg = c.bg },
    BufferVisibleSign                    = { fg = c.gray, bg = c.bg },
    BufferVisibleTarget                  = { fg = c.red, bg = c.bg, style = 'bold' },
    -- Cmp
    CmpDocumentation                     = { fg = c.fg, bg = c.none },
    CmpDocumentationBorder               = { fg = c.gray, bg = c.none },
    CmpItemAbbr                          = { fg = c.fg, bg = c.none },
    CmpItemAbbrDeprecated                = { fg = c.gray, bg = c.none },
    CmpItemAbbrMatch                     = { fg = c.cyan, bg = c.none },
    CmpItemAbbrMatchFuzzy                = { fg = c.cyan, bg = c.none },
    CmpItemKind                          = { fg = c.blue, bg = c.none },
    CmpItemMenu                          = { fg = c.light_gray, bg = c.none },
    -- Dashboard
    DashboardCenter                      = { fg = c.purple },
    DashboardFooter                      = { fg = c.cyan },
    DashboardHeader                      = { fg = c.blue },
    -- Debug
    debugBreakpoint                      = { fg = c.red, style = 'reverse' },
    debugPc                              = { bg = c.cyan },
    -- Diffview
    --DiffViewNormal = { fg = c.gray, bg = c.dark },
    --DiffviewFilePanelDeletion = { fg = c.diff_delete },
    --DiffviewFilePanelInsertion = { fg = c.diff_add },
    --DiffviewStatusAdded = { fg = c.diff_add },
    --DiffviewStatusDeleted = { fg = c.diff_delete },
    --DiffviewStatusModified = { fg = c.diff_change },
    --DiffviewStatusRenamed = { fg = c.diff_change },
    --DiffviewVertSplit = { bg = c.bg },

    -- Indent-blankline
    IndentBlanklineChar                  = { fg = c.dark_gray },
    IndentBlanklineContextChar           = { fg = c.context },
    IndentBlanklineSpaceChar             = { fg = c.blue },
    --IndentBlanklineSpaceCharBlankline = { fg = c.info_yellow },
    -- Lsp
    DiagnosticFloatingError              = { fg = c.error_red },
    DiagnosticFloatingHint               = { fg = c.hint_blue },
    DiagnosticFloatingInfo               = { fg = c.info_yellow },
    DiagnosticFloatingWarn               = { fg = c.warning_orange },
    DiagnosticSignError                  = { fg = c.Error },
    DiagnosticSignHint                   = { fg = c.Hint },
    DiagnosticSignInfo                   = { fg = c.Info },
    DiagnosticSignWarn                   = { fg = c.Warning },
    DiagnosticUnderlineError             = { style = 'underline' },
    DiagnosticUnderlineHint              = { style = 'underline' },
    DiagnosticUnderlineInfo              = { style = 'underline' },
    DiagnosticUnderlineWarn              = { style = 'underline' },
    LspDiagnosticsDefaultError           = { fg = c.Error },
    LspDiagnosticsDefaultHint            = { fg = c.Hint },
    LspDiagnosticsDefaultInformation     = { fg = c.Info },
    LspDiagnosticsDefaultWarning         = { fg = c.Warning },
    LspDiagnosticsError                  = { fg = c.Error },
    LspDiagnosticsFloatingError          = { fg = c.Error },
    LspDiagnosticsFloatingHint           = { fg = c.Hint },
    LspDiagnosticsFloatingInformation    = { fg = c.Info },
    LspDiagnosticsFloatingWarning        = { fg = c.Warning },
    LspDiagnosticsHint                   = { fg = c.Hint },
    LspDiagnosticsInformation            = { fg = c.Info },
    LspDiagnosticsSignError              = { fg = c.Error },
    LspDiagnosticsSignHint               = { fg = c.Hint },
    LspDiagnosticsSignInformation        = { fg = c.Info },
    LspDiagnosticsSignWarning            = { fg = c.Warning },
    LspDiagnosticsUnderlineError         = { style = 'underline' },
    LspDiagnosticsUnderlineHint          = { style = 'underline' },
    LspDiagnosticsUnderlineInformation   = { style = 'underline' },
    LspDiagnosticsUnderlineWarning       = { style = 'underline' },
    LspDiagnosticsVirtualTextError       = { fg = c.Error },
    LspDiagnosticsVirtualTextHint        = { fg = c.Hint },
    LspDiagnosticsVirtualTextInformation = { fg = c.Info },
    LspDiagnosticsVirtualTextWarning     = { fg = c.Warning },
    LspDiagnosticsWarning                = { fg = c.Warning },
    LspReferenceRead                     = { bg = c.fg_gutter, style = 'bold' },
    LspReferenceText                     = { bg = c.fg_gutter, style = 'bold' },
    LspReferenceWrite                    = { bg = c.fg_gutter, style = 'bold' },


    -- Telescope
    TelescopeBorder       = { fg = c.light_gray, bg = config.transparent_background and 'NONE' or c.bg },
    TelescopeMatching     = { fg = c.Info, style = 'bold' },
    TelescopePromptPrefix = { fg = c.Yellow },
    TelescopeSelection    = { fg = c.Hint },

    -- Treesitter
    TSAnnotation          = { fg = c.Yellow },
    TSAttribute           = { fg = c.Cyan },
    TSBoolean             = { fg = c.DarkBlue },
    TSCharacter           = { fg = c.LightOrange },
    TSComment             = { fg = c.Comment },
    TSConditional         = { fg = c.Purple },
    TSConstBuiltin        = { fg = c.blue },
    TSConstMacro          = { fg = c.Cyan },
    TSConstant            = { fg = c.LightGreen },
    TSConstructor         = { fg = c.Cyan },
    TSEmphasis            = { style = 'italic' },
    TSError               = { fg = c.Red },
    TSException           = { fg = c.Red },
    TSField               = { fg = c.LightBlue },
    TSFloat               = { fg = c.LightGreen },
    TSFuncBuiltin         = { fg = c.Yellow },
    TSFuncMacro           = { fg = c.Yellow },
    TSFunction            = { fg = c.Yellow },
    TSInclude             = { fg = c.DarkBlue },
    TSKeyword             = { fg = c.DarkBlue },
    TSKeywordFunction     = { fg = c.blue },
    TSKeywordOperator     = { fg = c.blue },
    TSKeywordReturn       = { fg = c.purple },
    TSLabel               = { fg = c.light_blue },
    TSLiteral             = { fg = c.yellow_orange },
    TSMethod              = { fg = c.Yellow },
    TSNamespace           = { fg = c.Cyan },
    TSNumber              = { fg = c.LightGreen },
    TSOperator            = { fg = c.fg },
    TSParameter           = { fg = c.LightGreen },
    TSParameterReference  = { fg = c.LightBlue },
    TSProperty            = { fg = c.LightBlue },
    TSPunctBracket        = { fg = c.fg },
    TSPunctDelimiter      = { fg = c.fg },
    TSPunctSpecial        = { fg = c.fg },
    --TSQueryLinterError = { fg = c.warning_orange },
    TSRepeat              = { fg = c.purple },
    TSString              = { fg = c.LightOrange },
    TSStringEscape        = { fg = c.yellow_orange },
    TSStringRegex         = { fg = c.orange },
    TSStrong              = { fg = c.yellow_orange },
    TSStructure           = { fg = c.LightGreen },
    TSSymbol              = { fg = c.light_blue },
    TSTag                 = { fg = c.blue },
    TSTagDelimiter        = { fg = c.gray },
    TSText                = { fg = c.fg },
    TSTitle               = { fg = c.blue, style = 'bold' },
    TSType                = { fg = c.Type },
    TSTypeBuiltin         = { fg = c.Type },
    TSURI                 = { fg = c.yellow_orange, style = 'underline' },
    TSUnderline           = { style = 'underline' },
    TSVariable            = { fg = c.LightBlue },
    variable              = { fg = c.LightBlue },
    TSVariableBuiltin     = { fg = c.LightBlue },
    TSOperatorLua         = { fg = c.gray },
}

--[[
M.lsp = {
    ["@lsp.type.property"] = { fg = c.LightBlue },
}
]] --
M.treesitter = {
    ["@variable"] = { fg = c.Reference },
    ["@string"] = { fg = c.ReferenceImmutable },
}

M.csharp = {
    --["@lsp.type.namespace.cs"] = { fg = c.Type },       -- lsp
    csPreProcDeclaration   = { fg = c.Preprocessor },
    csXmlLineComment       = { fg = c.Documentation },
    csXmlLineCommentLeader = { fg = c.Documentation },
}

M.gdscript = {
    gdscriptTypeDecl  = { fg = c.Type },
    --  gdscriptType      = { fg = c.Type },
    gdscriptStatement = { fg = c.KeyWord },
}

--[[
M.neoscroll = {
  NeoscrollHiddenCursor
}
M.yazi = {
    YaziBufferHovered
    YaziBufferHoveredInSameDirectory
}
]] --

M.gitgutter = {
    GitGutterAdd        = { fg = c.DiffAdd },
    GitGutterAddLine    = { fg = c.DiffAdd },
    GitGutterChange     = { fg = c.DiffChange },
    GitGutterChangeLine = { fg = c.DiffChange },
    GitGutterDelete     = { fg = c.DiffDelete },
    GitGutterDeleteLine = { fg = c.DiffDelete },
}

M.harpoon = {
    HarpoonInactive       = { fg = c.DarkGray },
    HarpoonActive         = { fg = c.fg },
    HarpoonNumberActive   = { fg = c.Accent },
    HarpoonNumberInactive = { fg = c.Accent }
}

M.gitsigns = {
    GitSignsAdd = { fg = c.DiffAdd },
    GitSignsChange = { fg = c.DiffChange },
    GitSignsDelete = { fg = c.DiffDelete },
    --GitSignsDeleteLn = { fg = c.DiffDelete }
}

M.avante = {
    AvanteTitle = { fg = c.blue, bg = c.dark, style = 'bold' },
    AvanteReversedTitle = { fg = c.dark, bg = c.blue, style = 'bold' },
    AvanteSubtitle = { fg = c.cyan, bg = c.dark },
    AvanteReversedSubtitle = { fg = c.dark, bg = c.cyan },
    AvanteThirdTitle = { fg = c.purple, bg = c.dark },
    AvanteReversedThirdTitle = { fg = c.dark, bg = c.purple },
    AvanteConflictCurrent = { fg = c.fg, bg = c.DiffAdd },
    AvanteConflictIncoming = { fg = c.fg, bg = c.DiffChange },
    AvanteConflictCurrentLabel = { fg = c.dark, bg = c.green, style = 'bold' },
    AvanteConflictIncomingLabel = { fg = c.dark, bg = c.blue, style = 'bold' },
    AvantePopupHint = { fg = c.Hint, bg = c.popup_back },
    AvanteCursor = { fg = c.CursorFG, bg = c.CursorBG },
    AvanteInlineHint = { fg = c.gray, bg = c.dark, style = 'italic' },
    AvanteReversedInlineHint = { fg = c.dark, bg = c.gray, style = 'italic' },
    AvanteSidebarWinSeparator = { fg = c.PanelEdges, bg = c.bg },
    AvanteSidebarWinHorizontalSeparator = { fg = c.PanelEdges, bg = c.bg },
    AvanteSidebarNormal = { fg = c.fg, bg = c.bg },
}

--[[

M.scrollbar = {
  Scrollbar
  ScrollbarCursor
  ScrollbarCursorHandle
  ScrollbarError
  ScrollbarErrorHandle
  ScrollbarGitAdd
  ScrollbarGitAddHandle
  ScrollbarGitChange
  ScrollbarGitChangeHandle
  ScrollbarGitDelete
  ScrollbarGitDeleteHandle
  ScrollbarHandle
  ScrollbarHint
  ScrollbarHintHandle
  ScrollbarInfo
  ScrollbarInfoHandle
  ScrollbarMisc
  ScrollbarMiscHandle
  ScrollbarSearch
  ScrollbarSearchHandle
  ScrollbarWarn
  ScrollbarWarnHandle
}
]] --

return M
