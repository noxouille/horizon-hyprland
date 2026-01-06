-- ============================================================================
-- horizon - Neovim Colorscheme
-- ============================================================================

local M = {}

M.colors = require("horizon.palette").colors

function M.setup(opts)
    opts = opts or {}

    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end

    vim.o.termguicolors = true
    vim.g.colors_name = "horizon"

    local highlights = require("horizon.highlights")
    highlights.setup(M.colors)
end

M.lualine = require("horizon.lualine").theme

return M
