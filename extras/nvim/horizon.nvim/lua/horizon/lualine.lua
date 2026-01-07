-- ============================================================================
-- horizon - Lualine Theme
-- ============================================================================

local colors = require("horizon.palette").colors

local M = {}

M.theme = {
    normal = {
        a = { fg = colors.bg0, bg = colors.van, gui = "bold" },
        b = { fg = colors.fg0, bg = colors.bg5 },
        c = { fg = colors.fg0, bg = colors.bg4 },
    },
    insert = {
        a = { fg = colors.bg0, bg = colors.kevin, gui = "bold" },
        b = { fg = colors.fg0, bg = colors.bg5 },
        c = { fg = colors.fg0, bg = colors.bg4 },
    },
    visual = {
        a = { fg = colors.bg0, bg = colors.agnes, gui = "bold" },
        b = { fg = colors.fg0, bg = colors.bg5 },
        c = { fg = colors.fg0, bg = colors.bg4 },
    },
    replace = {
        a = { fg = colors.bg0, bg = colors.aaron, gui = "bold" },
        b = { fg = colors.fg0, bg = colors.bg5 },
        c = { fg = colors.fg0, bg = colors.bg4 },
    },
    command = {
        a = { fg = colors.bg0, bg = colors.emilia, gui = "bold" },
        b = { fg = colors.fg0, bg = colors.bg5 },
        c = { fg = colors.fg0, bg = colors.bg4 },
    },
    inactive = {
        a = { fg = colors.fg4, bg = colors.bg2 },
        b = { fg = colors.fg4, bg = colors.bg2 },
        c = { fg = colors.fg4, bg = colors.bg2 },
    },
}

return M
