-- ============================================================================
-- horizon - Highlight Groups
-- ============================================================================

local M = {}

function M.setup(c)
    local function hi(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    -- Editor
    hi("Normal", { fg = c.fg2, bg = c.bg2 })
    hi("NormalFloat", { fg = c.fg2, bg = c.bg1 })
    hi("NormalNC", { fg = c.fg3, bg = c.bg2 })
    hi("FloatBorder", { fg = c.bg5, bg = c.bg1 })
    hi("FloatTitle", { fg = c.van, bg = c.bg1, bold = true })

    hi("Cursor", { fg = c.bg0, bg = c.van })
    hi("CursorLine", { bg = c.bg3 })
    hi("CursorColumn", { bg = c.bg3 })
    hi("CursorLineNr", { fg = c.fg1, bold = true })
    hi("LineNr", { fg = c.bg5 })

    hi("SignColumn", { fg = c.fg4, bg = c.bg2 })
    hi("FoldColumn", { fg = c.bg5, bg = c.bg2 })
    hi("Folded", { fg = c.fg4, bg = c.bg3 })

    hi("ColorColumn", { bg = c.bg3 })
    hi("VertSplit", { fg = c.bg5 })
    hi("WinSeparator", { fg = c.bg5 })

    hi("Visual", { bg = c.bg4 })
    hi("VisualNOS", { bg = c.bg3 })

    hi("Search", { fg = c.bg0, bg = c.feri })
    hi("IncSearch", { fg = c.bg0, bg = c.judith })
    hi("CurSearch", { fg = c.bg0, bg = c.judith })
    hi("Substitute", { fg = c.bg0, bg = c.aaron })

    hi("MatchParen", { fg = c.judith, bold = true })

    hi("Conceal", { fg = c.fg4 })
    hi("Whitespace", { fg = c.bg4 })
    hi("NonText", { fg = c.bg4 })
    hi("SpecialKey", { fg = c.bg5 })

    hi("Directory", { fg = c.van })
    hi("Title", { fg = c.van, bold = true })
    hi("Question", { fg = c.feri })
    hi("MoreMsg", { fg = c.elaine })
    hi("ModeMsg", { fg = c.fg2, bold = true })
    hi("WarningMsg", { fg = c.feri })
    hi("ErrorMsg", { fg = c.aaron, bold = true })

    hi("WildMenu", { fg = c.bg0, bg = c.van })

    -- Pmenu
    hi("Pmenu", { fg = c.fg2, bg = c.bg1 })
    hi("PmenuSel", { fg = c.fg0, bg = c.bg4 })
    hi("PmenuSbar", { bg = c.bg3 })
    hi("PmenuThumb", { bg = c.bg5 })

    -- Tabline
    hi("TabLine", { fg = c.fg4, bg = c.bg1 })
    hi("TabLineFill", { bg = c.bg1 })
    hi("TabLineSel", { fg = c.fg0, bg = c.bg2, bold = true })

    -- Statusline
    hi("StatusLine", { fg = c.fg3, bg = c.bg0 })
    hi("StatusLineNC", { fg = c.fg5, bg = c.bg1 })

    -- Diff
    hi("DiffAdd", { bg = "#1f3a30" })
    hi("DiffChange", { bg = "#2a3444" })
    hi("DiffDelete", { bg = "#3d2a2a" })
    hi("DiffText", { bg = "#3a4455" })

    hi("diffAdded", { fg = c.elaine })
    hi("diffRemoved", { fg = c.aaron })
    hi("diffChanged", { fg = c.van })
    hi("diffFile", { fg = c.feri })
    hi("diffLine", { fg = c.fg4 })

    -- Spell
    hi("SpellBad", { sp = c.aaron, undercurl = true })
    hi("SpellCap", { sp = c.feri, undercurl = true })
    hi("SpellLocal", { sp = c.van, undercurl = true })
    hi("SpellRare", { sp = c.risette, undercurl = true })

    -- Diagnostics
    hi("DiagnosticError", { fg = c.aaron })
    hi("DiagnosticWarn", { fg = c.feri })
    hi("DiagnosticInfo", { fg = c.risette })
    hi("DiagnosticHint", { fg = c.elaine })
    hi("DiagnosticOk", { fg = c.elaine })

    hi("DiagnosticUnderlineError", { sp = c.aaron, undercurl = true })
    hi("DiagnosticUnderlineWarn", { sp = c.feri, undercurl = true })
    hi("DiagnosticUnderlineInfo", { sp = c.risette, undercurl = true })
    hi("DiagnosticUnderlineHint", { sp = c.elaine, undercurl = true })

    hi("DiagnosticVirtualTextError", { fg = c.aaron, bg = "#2d2228" })
    hi("DiagnosticVirtualTextWarn", { fg = c.feri, bg = "#2d2a22" })
    hi("DiagnosticVirtualTextInfo", { fg = c.risette, bg = "#222a35" })
    hi("DiagnosticVirtualTextHint", { fg = c.elaine, bg = "#1f3330" })

    hi("DiagnosticSignError", { fg = c.aaron })
    hi("DiagnosticSignWarn", { fg = c.feri })
    hi("DiagnosticSignInfo", { fg = c.risette })
    hi("DiagnosticSignHint", { fg = c.elaine })

    -- Syntax
    hi("Comment", { fg = c.fg4, italic = true })
    hi("Constant", { fg = c.feri })
    hi("String", { fg = c.elaine })
    hi("Character", { fg = c.elaine })
    hi("Number", { fg = c.feri })
    hi("Boolean", { fg = c.feri })
    hi("Float", { fg = c.feri })

    hi("Identifier", { fg = c.fg1 })
    hi("Function", { fg = c.van })

    hi("Statement", { fg = c.agnes })
    hi("Conditional", { fg = c.agnes })
    hi("Repeat", { fg = c.agnes })
    hi("Label", { fg = c.agnes })
    hi("Operator", { fg = c.fg3 })
    hi("Keyword", { fg = c.agnes })
    hi("Exception", { fg = c.agnes })

    hi("PreProc", { fg = c.risette })
    hi("Include", { fg = c.risette })
    hi("Define", { fg = c.agnes })
    hi("Macro", { fg = c.agnes })
    hi("PreCondit", { fg = c.risette })

    hi("Type", { fg = c.risette })
    hi("StorageClass", { fg = c.agnes })
    hi("Structure", { fg = c.risette })
    hi("Typedef", { fg = c.risette })

    hi("Special", { fg = c.judith })
    hi("SpecialChar", { fg = c.judith })
    hi("Tag", { fg = c.agnes })
    hi("Delimiter", { fg = c.fg3 })
    hi("SpecialComment", { fg = c.fg4 })
    hi("Debug", { fg = c.aaron })

    hi("Underlined", { fg = c.risette, underline = true })
    hi("Ignore", { fg = c.fg5 })
    hi("Error", { fg = c.aaron })
    hi("Todo", { fg = c.bg0, bg = c.feri, bold = true })

    -- Treesitter
    hi("@variable", { fg = c.fg1 })
    hi("@variable.builtin", { fg = c.agnes })
    hi("@variable.parameter", { fg = c.fg1 })
    hi("@variable.member", { fg = c.quatre })

    hi("@constant", { fg = c.feri })
    hi("@constant.builtin", { fg = c.feri })
    hi("@constant.macro", { fg = c.feri })

    hi("@module", { fg = c.risette })
    hi("@label", { fg = c.agnes })

    hi("@string", { fg = c.elaine })
    hi("@string.escape", { fg = c.risette })
    hi("@string.special", { fg = c.risette })
    hi("@string.regex", { fg = c.risette })

    hi("@character", { fg = c.elaine })
    hi("@character.special", { fg = c.risette })

    hi("@boolean", { fg = c.feri })
    hi("@number", { fg = c.feri })
    hi("@number.float", { fg = c.feri })

    hi("@type", { fg = c.risette })
    hi("@type.builtin", { fg = c.risette })
    hi("@type.definition", { fg = c.risette })
    hi("@type.qualifier", { fg = c.agnes })

    hi("@attribute", { fg = c.judith })
    hi("@property", { fg = c.quatre })

    hi("@function", { fg = c.van })
    hi("@function.builtin", { fg = c.van })
    hi("@function.macro", { fg = c.agnes })
    hi("@function.method", { fg = c.van })

    hi("@constructor", { fg = c.risette })

    hi("@keyword", { fg = c.agnes })
    hi("@keyword.function", { fg = c.agnes })
    hi("@keyword.operator", { fg = c.agnes })
    hi("@keyword.return", { fg = c.agnes })
    hi("@keyword.import", { fg = c.risette })
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
    hi("@comment.warning", { fg = c.feri })
    hi("@comment.todo", { fg = c.bg0, bg = c.feri, bold = true })
    hi("@comment.note", { fg = c.risette })

    hi("@markup.heading", { fg = c.van, bold = true })
    hi("@markup.strong", { bold = true })
    hi("@markup.italic", { italic = true })
    hi("@markup.strikethrough", { strikethrough = true })
    hi("@markup.underline", { underline = true })
    hi("@markup.link", { fg = c.risette, underline = true })
    hi("@markup.link.url", { fg = c.risette, underline = true })
    hi("@markup.raw", { fg = c.elaine })
    hi("@markup.list", { fg = c.agnes })
    hi("@markup.quote", { fg = c.fg3, italic = true })

    hi("@diff.plus", { fg = c.elaine })
    hi("@diff.minus", { fg = c.aaron })
    hi("@diff.delta", { fg = c.van })

    hi("@tag", { fg = c.agnes })
    hi("@tag.attribute", { fg = c.feri })
    hi("@tag.delimiter", { fg = c.fg3 })

    -- LSP
    hi("LspReferenceText", { bg = c.bg4 })
    hi("LspReferenceRead", { bg = c.bg4 })
    hi("LspReferenceWrite", { bg = c.bg4 })

    hi("LspSignatureActiveParameter", { fg = c.feri, bold = true })

    hi("LspCodeLens", { fg = c.fg4 })
    hi("LspCodeLensSeparator", { fg = c.bg5 })

    -- Git Signs
    hi("GitSignsAdd", { fg = c.elaine })
    hi("GitSignsChange", { fg = c.van })
    hi("GitSignsDelete", { fg = c.aaron })

    -- Telescope
    hi("TelescopeNormal", { fg = c.fg2, bg = c.bg1 })
    hi("TelescopeBorder", { fg = c.bg5, bg = c.bg1 })
    hi("TelescopeTitle", { fg = c.van, bold = true })
    hi("TelescopePromptNormal", { fg = c.fg2, bg = c.bg3 })
    hi("TelescopePromptBorder", { fg = c.bg5, bg = c.bg3 })
    hi("TelescopePromptTitle", { fg = c.van, bg = c.bg3, bold = true })
    hi("TelescopePromptPrefix", { fg = c.van })
    hi("TelescopeSelection", { bg = c.bg4 })
    hi("TelescopeSelectionCaret", { fg = c.van })
    hi("TelescopeMatching", { fg = c.feri, bold = true })

    -- nvim-cmp
    hi("CmpItemAbbrMatch", { fg = c.van, bold = true })
    hi("CmpItemAbbrMatchFuzzy", { fg = c.van })
    hi("CmpItemKindVariable", { fg = c.fg1 })
    hi("CmpItemKindFunction", { fg = c.van })
    hi("CmpItemKindMethod", { fg = c.van })
    hi("CmpItemKindKeyword", { fg = c.agnes })
    hi("CmpItemKindProperty", { fg = c.quatre })
    hi("CmpItemKindUnit", { fg = c.feri })
    hi("CmpItemKindClass", { fg = c.risette })
    hi("CmpItemKindStruct", { fg = c.risette })
    hi("CmpItemKindInterface", { fg = c.risette })
    hi("CmpItemKindText", { fg = c.fg2 })
    hi("CmpItemKindSnippet", { fg = c.elaine })
    hi("CmpItemKindFile", { fg = c.fg2 })
    hi("CmpItemKindFolder", { fg = c.van })

    -- Lazy
    hi("LazyButton", { fg = c.fg2, bg = c.bg3 })
    hi("LazyButtonActive", { fg = c.fg0, bg = c.van })
    hi("LazyH1", { fg = c.bg0, bg = c.van, bold = true })

    -- Mason
    hi("MasonHeader", { fg = c.bg0, bg = c.van, bold = true })
    hi("MasonHighlight", { fg = c.van })
    hi("MasonHighlightBlock", { fg = c.bg0, bg = c.van })
    hi("MasonHighlightBlockBold", { fg = c.bg0, bg = c.van, bold = true })

    -- NeoTree
    hi("NeoTreeNormal", { fg = c.fg2, bg = c.bg1 })
    hi("NeoTreeNormalNC", { fg = c.fg2, bg = c.bg1 })
    hi("NeoTreeDirectoryName", { fg = c.van })
    hi("NeoTreeDirectoryIcon", { fg = c.van })
    hi("NeoTreeRootName", { fg = c.van, bold = true })
    hi("NeoTreeFileName", { fg = c.fg2 })
    hi("NeoTreeGitAdded", { fg = c.elaine })
    hi("NeoTreeGitModified", { fg = c.van })
    hi("NeoTreeGitDeleted", { fg = c.aaron })
    hi("NeoTreeGitUntracked", { fg = c.risette })

    -- Which-key
    hi("WhichKey", { fg = c.van })
    hi("WhichKeyGroup", { fg = c.agnes })
    hi("WhichKeyDesc", { fg = c.fg2 })
    hi("WhichKeySeparator", { fg = c.fg4 })
    hi("WhichKeyValue", { fg = c.fg3 })

    -- Indent Blankline
    hi("IblIndent", { fg = c.bg4 })
    hi("IblScope", { fg = c.bg5 })

    -- Noice
    hi("NoiceCmdlinePopupBorder", { fg = c.bg5 })
    hi("NoiceCmdlineIcon", { fg = c.van })

    -- Notify
    hi("NotifyERRORBorder", { fg = c.aaron })
    hi("NotifyWARNBorder", { fg = c.feri })
    hi("NotifyINFOBorder", { fg = c.risette })
    hi("NotifyDEBUGBorder", { fg = c.fg4 })
    hi("NotifyTRACEBorder", { fg = c.bergard })
    hi("NotifyERRORIcon", { fg = c.aaron })
    hi("NotifyWARNIcon", { fg = c.feri })
    hi("NotifyINFOIcon", { fg = c.risette })
    hi("NotifyDEBUGIcon", { fg = c.fg4 })
    hi("NotifyTRACEIcon", { fg = c.bergard })
    hi("NotifyERRORTitle", { fg = c.aaron })
    hi("NotifyWARNTitle", { fg = c.feri })
    hi("NotifyINFOTitle", { fg = c.risette })
    hi("NotifyDEBUGTitle", { fg = c.fg4 })
    hi("NotifyTRACETitle", { fg = c.bergard })
end

return M
