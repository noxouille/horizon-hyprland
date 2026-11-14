-- ============================================================================
-- Horizon - Color Palette (Light Theme)
-- ============================================================================
-- Inspired by "Trails beyond the Horizon" - Kai no Kiseki Edition
-- Colors based on the crossover protagonists and artifacts

local M = {}

M.colors = {
    -- Backgrounds (warm gray spectrum from promotional art)
    bg0 = "#CDC9C2",  -- Lightest - main background
    bg1 = "#C5C1BA",  -- Sidebars, panels
    bg2 = "#BCB8B1",  -- Elevated surfaces
    bg3 = "#B3AFA8",  -- Hover states, selections
    bg4 = "#A19D96",  -- Borders, separators
    bg5 = "#837F79",  -- Strong borders, scrollbars

    -- Foregrounds (dark spectrum for contrast on light)
    fg0 = "#1A1816",  -- Darkest - headings, emphasis
    fg1 = "#2A2826",  -- Primary text
    fg2 = "#34322F",  -- Body text
    fg3 = "#4C4945",  -- Subtle text, labels
    fg4 = "#57534D",  -- Comments, placeholders
    fg5 = "#7A766F",  -- Very muted, disabled

    -- Character Colors
    -- Van Arkride - Deep steel blue protagonist (PROMINENT)
    van = "#1E3A5F",
    van_bright = "#2D4A6E",

    -- Kevin Graham - Saturated green priest (PROMINENT)
    kevin = "#1C5E24",
    kevin_bright = "#2C6B30",

    -- Rean Schwarzer - Dark warm brown Chevalier (PROMINENT)
    rean = "#4A423B",
    rean_bright = "#5A514A",

    -- Agnès Claudel - Rich magenta wielder
    agnes = "#8C0F45",
    agnes_bright = "#A01250",

    -- Emilia - Dark amber/brown racer (darkened for light theme)
    emilia = "#5C3A00",
    emilia_bright = "#6B4500",

    -- Grandmaster - Rich purple enigma
    grandmaster = "#571583",
    grandmaster_bright = "#65189A",

    -- Laegjarn's Chest - Dark teal artifact (darkened for light theme)
    laegjarn = "#00473E",
    laegjarn_bright = "#005A4F",

    -- Horizon - Dark burnt orange (darkened for light theme)
    horizon = "#8A3100",
    horizon_bright = "#A33D00",

    -- Aaron Wei - Vibrant red swordsman
    aaron = "#9E1C1C",
    aaron_bright = "#A82222",

    none = "NONE",
}

-- Kitty and foot apply background_opacity only to cells whose background equals
-- the terminal's default background. bg0 is also the kitty and foot background,
-- so an editor painted in bg0 lets the wallpaper show through. Shift the blue
-- channel by one step: the same color to the eye, but opaque in the terminal.
local function opaque_twin(hex)
    local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
    b = tonumber(b, 16)
    b = b > 0 and b - 1 or b + 1
    return string.format("#%s%s%02X", r, g, b)
end

M.colors.bg_editor = opaque_twin(M.colors.bg0)

return M
