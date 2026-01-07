-- ============================================================================
-- Horizon - Highlight Groups (Light Theme)
-- ============================================================================

local M = {}

function M.setup(c)
    local function hi(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    -- Editor
    hi("Normal", { fg = c.fg2, bg = c.bg0 })
    hi("NormalFloat", { fg = c.fg0, bg = c.bg1 })
    hi("NormalNC", { fg = c.fg3, bg = c.bg0 })
    hi("FloatBorder", { fg = c.bg5, bg = c.bg1 })
    hi("FloatTitle", { fg = c.van, bg = c.bg1, bold = true })

    hi("Cursor", { fg = c.bg0, bg = c.van })
    hi("CursorLine", { bg = c.bg2 })
    hi("CursorColumn", { bg = c.bg2 })
    hi("CursorLineNr", { fg = c.fg1, bold = true })
    hi("LineNr", { fg = c.bg5 })

    hi("SignColumn", { fg = c.fg4, bg = c.bg0 })
    hi("FoldColumn", { fg = c.bg5, bg = c.bg0 })
    hi("Folded", { fg = c.fg4, bg = c.bg2 })

    hi("ColorColumn", { bg = c.bg2 })
    hi("VertSplit", { fg = c.bg4 })
    hi("WinSeparator", { fg = c.bg4 })

    hi("Visual", { bg = c.bg3 })
    hi("VisualNOS", { bg = c.bg2 })

    hi("Search", { fg = c.bg0, bg = c.emilia })
    hi("IncSearch", { fg = c.bg0, bg = c.horizon })
    hi("CurSearch", { fg = c.bg0, bg = c.horizon })
    hi("Substitute", { fg = c.bg0, bg = c.aaron })

    hi("MatchParen", { fg = c.horizon, bold = true })

    hi("Conceal", { fg = c.fg4 })
    hi("Whitespace", { fg = c.bg4 })
    hi("NonText", { fg = c.bg4 })
    hi("SpecialKey", { fg = c.bg5 })

    hi("Directory", { fg = c.van })
    hi("Title", { fg = c.van, bold = true })
    hi("Question", { fg = c.emilia })
    hi("MoreMsg", { fg = c.kevin })
    hi("ModeMsg", { fg = c.fg2, bold = true })
    hi("WarningMsg", { fg = c.horizon })
    hi("ErrorMsg", { fg = c.aaron, bold = true })

    hi("WildMenu", { fg = c.bg0, bg = c.van })

    -- Pmenu
    hi("Pmenu", { fg = c.fg2, bg = c.bg1 })
    hi("PmenuSel", { fg = c.fg0, bg = c.bg3 })
    hi("PmenuSbar", { bg = c.bg2 })
    hi("PmenuThumb", { bg = c.bg5 })

    -- Tabline
    hi("TabLine", { fg = c.fg4, bg = c.bg1 })
    hi("TabLineFill", { bg = c.bg1 })
    hi("TabLineSel", { fg = c.fg0, bg = c.bg0, bold = true })

    -- Statusline
    hi("StatusLine", { fg = c.fg2, bg = c.bg2 })
    hi("StatusLineNC", { fg = c.fg5, bg = c.bg1 })

    -- Diff (adjusted for light theme)
    hi("DiffAdd", { bg = "#d0e8d0" })
    hi("DiffChange", { bg = "#d8dce8" })
    hi("DiffDelete", { bg = "#e8d0d0" })
    hi("DiffText", { bg = "#c8d0e0" })

    hi("diffAdded", { fg = c.kevin })
    hi("diffRemoved", { fg = c.aaron })
    hi("diffChanged", { fg = c.van })
    hi("diffFile", { fg = c.emilia })
    hi("diffLine", { fg = c.fg4 })

    -- Spell
    hi("SpellBad", { sp = c.aaron, undercurl = true })
    hi("SpellCap", { sp = c.horizon, undercurl = true })
    hi("SpellLocal", { sp = c.van, undercurl = true })
    hi("SpellRare", { sp = c.laegjarn, undercurl = true })

    -- Diagnostics
    hi("DiagnosticError", { fg = c.aaron })
    hi("DiagnosticWarn", { fg = c.horizon })
    hi("DiagnosticInfo", { fg = c.laegjarn })
    hi("DiagnosticHint", { fg = c.kevin })
    hi("DiagnosticOk", { fg = c.kevin })

    hi("DiagnosticUnderlineError", { sp = c.aaron, undercurl = true })
    hi("DiagnosticUnderlineWarn", { sp = c.horizon, undercurl = true })
    hi("DiagnosticUnderlineInfo", { sp = c.laegjarn, undercurl = true })
    hi("DiagnosticUnderlineHint", { sp = c.kevin, undercurl = true })

    hi("DiagnosticVirtualTextError", { fg = c.aaron, bg = "#e8d0d0" })
    hi("DiagnosticVirtualTextWarn", { fg = c.horizon, bg = "#e8dcd0" })
    hi("DiagnosticVirtualTextInfo", { fg = c.laegjarn, bg = "#d0e0e0" })
    hi("DiagnosticVirtualTextHint", { fg = c.kevin, bg = "#d0e8d0" })

    hi("DiagnosticSignError", { fg = c.aaron })
    hi("DiagnosticSignWarn", { fg = c.horizon })
    hi("DiagnosticSignInfo", { fg = c.laegjarn })
    hi("DiagnosticSignHint", { fg = c.kevin })

    -- Syntax
    hi("Comment", { fg = c.fg4, italic = true })
    hi("Constant", { fg = c.emilia })
    hi("String", { fg = c.kevin })
    hi("Character", { fg = c.kevin })
    hi("Number", { fg = c.emilia })
    hi("Boolean", { fg = c.emilia })
    hi("Float", { fg = c.emilia })

    hi("Identifier", { fg = c.fg1 })
    hi("Function", { fg = c.van })

    hi("Statement", { fg = c.agnes })
    hi("Conditional", { fg = c.agnes })
    hi("Repeat", { fg = c.agnes })
    hi("Label", { fg = c.agnes })
    hi("Operator", { fg = c.fg3 })
    hi("Keyword", { fg = c.agnes })
    hi("Exception", { fg = c.agnes })

    hi("PreProc", { fg = c.laegjarn })
    hi("Include", { fg = c.laegjarn })
    hi("Define", { fg = c.agnes })
    hi("Macro", { fg = c.agnes })
    hi("PreCondit", { fg = c.laegjarn })

    hi("Type", { fg = c.laegjarn })
    hi("StorageClass", { fg = c.agnes })
    hi("Structure", { fg = c.laegjarn })
    hi("Typedef", { fg = c.laegjarn })

    hi("Special", { fg = c.grandmaster })
    hi("SpecialChar", { fg = c.grandmaster })
    hi("Tag", { fg = c.agnes })
    hi("Delimiter", { fg = c.fg3 })
    hi("SpecialComment", { fg = c.fg4 })
    hi("Debug", { fg = c.aaron })

    hi("Underlined", { fg = c.laegjarn, underline = true })
    hi("Ignore", { fg = c.fg5 })
    hi("Error", { fg = c.aaron })
    hi("Todo", { fg = c.bg0, bg = c.horizon, bold = true })

    -- Treesitter
    hi("@variable", { fg = c.fg1 })
    hi("@variable.builtin", { fg = c.agnes })
    hi("@variable.parameter", { fg = c.fg1 })
    hi("@variable.member", { fg = c.rean })

    hi("@constant", { fg = c.emilia })
    hi("@constant.builtin", { fg = c.emilia })
    hi("@constant.macro", { fg = c.emilia })

    hi("@module", { fg = c.laegjarn })
    hi("@label", { fg = c.agnes })

    hi("@string", { fg = c.kevin })
    hi("@string.escape", { fg = c.laegjarn })
    hi("@string.special", { fg = c.laegjarn })
    hi("@string.regex", { fg = c.laegjarn })

    hi("@character", { fg = c.kevin })
    hi("@character.special", { fg = c.laegjarn })

    hi("@boolean", { fg = c.emilia })
    hi("@number", { fg = c.emilia })
    hi("@number.float", { fg = c.emilia })

    hi("@type", { fg = c.laegjarn })
    hi("@type.builtin", { fg = c.laegjarn })
    hi("@type.definition", { fg = c.laegjarn })
    hi("@type.qualifier", { fg = c.agnes })

    hi("@attribute", { fg = c.grandmaster })
    hi("@property", { fg = c.rean })

    hi("@function", { fg = c.van })
    hi("@function.builtin", { fg = c.van })
    hi("@function.macro", { fg = c.agnes })
    hi("@function.method", { fg = c.van })

    hi("@constructor", { fg = c.laegjarn })

    hi("@keyword", { fg = c.agnes })
    hi("@keyword.function", { fg = c.agnes })
    hi("@keyword.operator", { fg = c.agnes })
    hi("@keyword.return", { fg = c.agnes })
    hi("@keyword.import", { fg = c.laegjarn })
    hi("@keyword.modifier", { fg = c.agnes })
    hi("@keyword.repeat", { fg = c.agnes })
    hi("@keyword.conditional", { fg = c.agnes })
    hi("@keyword.exception", { fg = c.agnes })

    hi("@operator", { fg = c.fg3 })

    hi("@punctuation.delimiter", { fg = c.fg3 })
    hi("@punctuation.bracket", { fg = c.fg3 })
    hi("@punctuation.special", { fg = c.fg3 })

    hi("@comment", { fg = c.fg4, italic = true })
    hi("@comment.error", { fg = c.aaron })
    hi("@comment.warning", { fg = c.horizon })
    hi("@comment.todo", { fg = c.bg0, bg = c.horizon, bold = true })
    hi("@comment.note", { fg = c.laegjarn })

    hi("@markup.heading", { fg = c.van, bold = true })
    hi("@markup.strong", { bold = true })
    hi("@markup.italic", { italic = true })
    hi("@markup.strikethrough", { strikethrough = true })
    hi("@markup.underline", { underline = true })
    hi("@markup.link", { fg = c.laegjarn, underline = true })
    hi("@markup.link.url", { fg = c.laegjarn, underline = true })
    hi("@markup.raw", { fg = c.kevin })
    hi("@markup.list", { fg = c.agnes })
    hi("@markup.quote", { fg = c.fg3, italic = true })

    hi("@diff.plus", { fg = c.kevin })
    hi("@diff.minus", { fg = c.aaron })
    hi("@diff.delta", { fg = c.van })

    hi("@tag", { fg = c.agnes })
    hi("@tag.attribute", { fg = c.emilia })
    hi("@tag.delimiter", { fg = c.fg3 })

    -- LSP
    hi("LspReferenceText", { bg = c.bg3 })
    hi("LspReferenceRead", { bg = c.bg3 })
    hi("LspReferenceWrite", { bg = c.bg3 })

    hi("LspSignatureActiveParameter", { fg = c.horizon, bold = true })

    hi("LspCodeLens", { fg = c.fg4 })
    hi("LspCodeLensSeparator", { fg = c.bg5 })

    -- Git Signs
    hi("GitSignsAdd", { fg = c.kevin })
    hi("GitSignsChange", { fg = c.van })
    hi("GitSignsDelete", { fg = c.aaron })

    -- Telescope
    hi("TelescopeNormal", { fg = c.fg2, bg = c.bg1 })
    hi("TelescopeBorder", { fg = c.bg5, bg = c.bg1 })
    hi("TelescopeTitle", { fg = c.van, bold = true })
    hi("TelescopePromptNormal", { fg = c.fg2, bg = c.bg2 })
    hi("TelescopePromptBorder", { fg = c.bg5, bg = c.bg2 })
    hi("TelescopePromptTitle", { fg = c.van, bg = c.bg2, bold = true })
    hi("TelescopePromptPrefix", { fg = c.van })
    hi("TelescopeSelection", { bg = c.bg3 })
    hi("TelescopeSelectionCaret", { fg = c.van })
    hi("TelescopeMatching", { fg = c.horizon, bold = true })

    -- nvim-cmp
    hi("CmpItemAbbrMatch", { fg = c.van, bold = true })
    hi("CmpItemAbbrMatchFuzzy", { fg = c.van })
    hi("CmpItemKindVariable", { fg = c.fg1 })
    hi("CmpItemKindFunction", { fg = c.van })
    hi("CmpItemKindMethod", { fg = c.van })
    hi("CmpItemKindKeyword", { fg = c.agnes })
    hi("CmpItemKindProperty", { fg = c.rean })
    hi("CmpItemKindUnit", { fg = c.emilia })
    hi("CmpItemKindClass", { fg = c.laegjarn })
    hi("CmpItemKindStruct", { fg = c.laegjarn })
    hi("CmpItemKindInterface", { fg = c.laegjarn })
    hi("CmpItemKindText", { fg = c.fg2 })
    hi("CmpItemKindSnippet", { fg = c.kevin })
    hi("CmpItemKindFile", { fg = c.fg2 })
    hi("CmpItemKindFolder", { fg = c.van })

    -- Lazy
    hi("LazyButton", { fg = c.fg2, bg = c.bg2 })
    hi("LazyButtonActive", { fg = c.bg0, bg = c.van })
    hi("LazyH1", { fg = c.bg0, bg = c.van, bold = true })

    -- Mason
    hi("MasonHeader", { fg = c.bg0, bg = c.van, bold = true })
    hi("MasonHighlight", { fg = c.van })
    hi("MasonHighlightBlock", { fg = c.bg0, bg = c.van })
    hi("MasonHighlightBlockBold", { fg = c.bg0, bg = c.van, bold = true })

    -- NeoTree
    hi("NeoTreeNormal", { fg = c.fg0, bg = c.bg1 })
    hi("NeoTreeNormalNC", { fg = c.fg1, bg = c.bg1 })
    hi("NeoTreeDirectoryName", { fg = c.van })
    hi("NeoTreeDirectoryIcon", { fg = c.van })
    hi("NeoTreeRootName", { fg = c.van, bold = true })
    hi("NeoTreeFileName", { fg = c.fg0 })
    hi("NeoTreeCursorLine", { fg = c.fg0, bg = c.bg3 })
    hi("NeoTreeGitAdded", { fg = c.kevin })
    hi("NeoTreeGitModified", { fg = c.van })
    hi("NeoTreeGitDeleted", { fg = c.aaron })
    hi("NeoTreeGitUntracked", { fg = c.laegjarn })

    -- Which-key
    hi("WhichKey", { fg = c.van })
    hi("WhichKeyGroup", { fg = c.agnes })
    hi("WhichKeyDesc", { fg = c.fg2 })
    hi("WhichKeySeparator", { fg = c.fg4 })
    hi("WhichKeyValue", { fg = c.fg3 })

    -- Indent Blankline
    hi("IblIndent", { fg = c.bg3 })
    hi("IblScope", { fg = c.bg5 })

    -- Noice
    hi("NoiceCmdlinePopupBorder", { fg = c.bg5 })
    hi("NoiceCmdlineIcon", { fg = c.van })

    -- Hyprland
    hi("@lsp.type.hyprColor", { fg = c.van })

    -- Snacks
    hi("SnacksPickerDir", { fg = c.van })
    hi("SnacksPickerFile", { fg = c.fg0 })
    hi("SnacksPickerListCursorLine", { bg = c.bg3 })
    hi("SnacksPickerMatch", { fg = c.horizon, bold = true })
    hi("SnacksPickerTree", { fg = c.fg4 })
    hi("SnacksExplorerTree", { fg = c.fg4 })
    hi("SnacksExplorerDir", { fg = c.van })
    hi("SnacksExplorerFile", { fg = c.fg0 })
    hi("SnacksExplorerNormal", { fg = c.fg0, bg = c.bg1 })
    hi("SnacksPicker", { fg = c.fg0, bg = c.bg1 })
    hi("SnacksPickerList", { fg = c.fg0, bg = c.bg1 })
    hi("SnacksPickerListTitle", { fg = c.van, bold = true })
    hi("SnacksPickerGitStatusUntracked", { fg = c.fg1 })
    hi("SnacksPickerGitStatusIgnored", { fg = c.fg3 })
    hi("SnacksPickerGitStatusModified", { fg = c.van })
    hi("SnacksPickerGitStatusAdded", { fg = c.kevin })
    hi("SnacksPickerGitStatusDeleted", { fg = c.aaron })
    hi("SnacksPickerGitStatusRenamed", { fg = c.laegjarn })
    hi("SnacksPickerGitStatusStaged", { fg = c.kevin })

    -- Notify
    hi("NotifyERRORBorder", { fg = c.aaron })
    hi("NotifyWARNBorder", { fg = c.horizon })
    hi("NotifyINFOBorder", { fg = c.laegjarn })
    hi("NotifyDEBUGBorder", { fg = c.fg4 })
    hi("NotifyTRACEBorder", { fg = c.grandmaster })
    hi("NotifyERRORIcon", { fg = c.aaron })
    hi("NotifyWARNIcon", { fg = c.horizon })
    hi("NotifyINFOIcon", { fg = c.laegjarn })
    hi("NotifyDEBUGIcon", { fg = c.fg4 })
    hi("NotifyTRACEIcon", { fg = c.grandmaster })
    hi("NotifyERRORTitle", { fg = c.aaron })
    hi("NotifyWARNTitle", { fg = c.horizon })
    hi("NotifyINFOTitle", { fg = c.laegjarn })
    hi("NotifyDEBUGTitle", { fg = c.fg4 })
    hi("NotifyTRACETitle", { fg = c.grandmaster })

    -- Lualine (direct highlight groups for LazyVim)
    hi("lualine_a_normal", { fg = c.bg0, bg = c.van, bold = true })
    hi("lualine_b_normal", { fg = c.fg0, bg = c.bg5 })
    hi("lualine_c_normal", { fg = c.fg0, bg = c.bg4 })
    hi("lualine_a_insert", { fg = c.bg0, bg = c.kevin, bold = true })
    hi("lualine_b_insert", { fg = c.fg0, bg = c.bg5 })
    hi("lualine_c_insert", { fg = c.fg0, bg = c.bg4 })
    hi("lualine_a_visual", { fg = c.bg0, bg = c.agnes, bold = true })
    hi("lualine_b_visual", { fg = c.fg0, bg = c.bg5 })
    hi("lualine_c_visual", { fg = c.fg0, bg = c.bg4 })
    hi("lualine_a_replace", { fg = c.bg0, bg = c.aaron, bold = true })
    hi("lualine_b_replace", { fg = c.fg0, bg = c.bg5 })
    hi("lualine_c_replace", { fg = c.fg0, bg = c.bg4 })
    hi("lualine_a_command", { fg = c.bg0, bg = c.emilia, bold = true })
    hi("lualine_b_command", { fg = c.fg0, bg = c.bg5 })
    hi("lualine_c_command", { fg = c.fg0, bg = c.bg4 })
    hi("lualine_a_inactive", { fg = c.fg4, bg = c.bg2 })
    hi("lualine_b_inactive", { fg = c.fg4, bg = c.bg2 })
    hi("lualine_c_inactive", { fg = c.fg4, bg = c.bg2 })
end

return M
