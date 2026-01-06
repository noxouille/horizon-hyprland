-- ============================================================================
-- horizon - Lualine Theme
-- ============================================================================

local colors = require("horizon.palette").colors

local M = {}

M.theme = {
    normal = {
        a = { fg = colors.bg0, bg = colors.van, gui = "bold" },
        b = { fg = colors.fg2, bg = colors.bg3 },
        c = { fg = colors.fg3, bg = colors.bg1 },
    },
    insert = {
        a = { fg = colors.bg0, bg = colors.elaine, gui = "bold" },
        b = { fg = colors.fg2, bg = colors.bg3 },
        c = { fg = colors.fg3, bg = colors.bg1 },
    },
    visual = {
        a = { fg = colors.bg0, bg = colors.agnes, gui = "bold" },
        b = { fg = colors.fg2, bg = colors.bg3 },
        c = { fg = colors.fg3, bg = colors.bg1 },
    },
    replace = {
        a = { fg = colors.bg0, bg = colors.aaron, gui = "bold" },
        b = { fg = colors.fg2, bg = colors.bg3 },
        c = { fg = colors.fg3, bg = colors.bg1 },
    },
    command = {
        a = { fg = colors.bg0, bg = colors.feri, gui = "bold" },
        b = { fg = colors.fg2, bg = colors.bg3 },
        c = { fg = colors.fg3, bg = colors.bg1 },
    },
    inactive = {
        a = { fg = colors.fg4, bg = colors.bg1 },
        b = { fg = colors.fg4, bg = colors.bg1 },
        c = { fg = colors.fg4, bg = colors.bg1 },
    },
}

return M
