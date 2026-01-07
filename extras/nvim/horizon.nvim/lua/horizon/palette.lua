-- ============================================================================
-- Horizon - Color Palette (Light Theme)
-- ============================================================================
-- Inspired by "Trails beyond the Horizon" - Kai no Kiseki Edition
-- Colors based on the crossover protagonists and artifacts

local M = {}

M.colors = {
    -- Backgrounds (warm gray spectrum from promotional art)
    bg0 = "#D8D4D0",  -- Lightest - main background
    bg1 = "#CEC9C5",  -- Sidebars, panels
    bg2 = "#C4BFBA",  -- Elevated surfaces
    bg3 = "#BAB4AF",  -- Hover states, selections
    bg4 = "#A8A29D",  -- Borders, separators
    bg5 = "#8A8480",  -- Strong borders, scrollbars

    -- Foregrounds (dark spectrum for contrast on light)
    fg0 = "#1A1816",  -- Darkest - headings, emphasis
    fg1 = "#2A2826",  -- Primary text
    fg2 = "#3A3836",  -- Body text
    fg3 = "#5A5856",  -- Subtle text, labels
    fg4 = "#6A6866",  -- Comments, placeholders
    fg5 = "#8A8886",  -- Very muted, disabled

    -- Character Colors
    -- Van Arkride - Deep steel blue protagonist (PROMINENT)
    van = "#1E3A5F",
    van_bright = "#2D4A6E",

    -- Kevin Graham - Saturated green priest (PROMINENT)
    kevin = "#2E7D32",
    kevin_bright = "#4A7E2D",

    -- Rean Schwarzer - Dark warm brown Chevalier (PROMINENT)
    rean = "#4A423B",
    rean_bright = "#5A514A",

    -- Agnès Claudel - Rich magenta wielder
    agnes = "#AD1457",
    agnes_bright = "#C2185B",

    -- Emilia - Dark amber/brown racer (darkened for light theme)
    emilia = "#704700",
    emilia_bright = "#8B5A00",

    -- Grandmaster - Rich purple enigma
    grandmaster = "#6A1B9A",
    grandmaster_bright = "#7B1FA2",

    -- Laegjarn's Chest - Dark teal artifact (darkened for light theme)
    laegjarn = "#005A4F",
    laegjarn_bright = "#00695C",

    -- Horizon - Dark burnt orange (darkened for light theme)
    horizon = "#BF4400",
    horizon_bright = "#D04F00",

    -- Aaron Wei - Vibrant red swordsman
    aaron = "#C62828",
    aaron_bright = "#D32F2F",

    none = "NONE",
}

return M
