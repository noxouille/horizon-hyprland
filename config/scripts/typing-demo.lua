-- horizon Theme Typing Demo
-- Simulates typing code to showcase syntax highlighting

local code_samples = {
  lua = {
    filetype = "lua",
    code = [[
-- horizon Color Palette
local M = {}

M.colors = {
  bg0 = "#13171d",
  fg0 = "#c5cdd9",
  van = "#3D5A80",      -- Main blue
  agnes = "#8A5070",    -- Soft red
  feri = "#F8BA65",     -- Warm yellow
  aaron = "#B84444",    -- Bold red
  risette = "#A4D8EC",  -- Light cyan
}

function M.setup(opts)
  opts = opts or {}
  local colors = M.colors

  -- Apply highlights
  for group, settings in pairs(opts.highlights or {}) do
    vim.api.nvim_set_hl(0, group, settings)
  end

  return colors
end

return M]]
  },

  python = {
    filetype = "python",
    code = [[
#!/usr/bin/env python3
"""horizon Theme Generator"""

from dataclasses import dataclass
from typing import Dict, List

@dataclass
class Color:
    name: str
    hex: str
    rgb: tuple[int, int, int]

    def to_ansi(self) -> str:
        r, g, b = self.rgb
        return f"\033[38;2;{r};{g};{b}m"

class horizonPalette:
    COLORS: Dict[str, str] = {
        "van": "#3D5A80",
        "agnes": "#8A5070",
        "feri": "#F8BA65",
    }

    def __init__(self):
        self.colors: List[Color] = []
        for name, hex_val in self.COLORS.items():
            rgb = self._hex_to_rgb(hex_val)
            self.colors.append(Color(name, hex_val, rgb))

    @staticmethod
    def _hex_to_rgb(hex: str) -> tuple:
        h = hex.lstrip("#")
        return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

if __name__ == "__main__":
    palette = horizonPalette()
    for color in palette.colors:
        print(f"{color.to_ansi()}{color.name}: {color.hex}\033[0m")]]
  },

  rust = {
    filetype = "rust",
    code = [[
//! horizon Theme for Terminal

use std::collections::HashMap;

#[derive(Debug, Clone)]
pub struct Color {
    pub name: &'static str,
    pub hex: &'static str,
    pub rgb: (u8, u8, u8),
}

impl Color {
    pub const fn new(name: &'static str, hex: &'static str, rgb: (u8, u8, u8)) -> Self {
        Self { name, hex, rgb }
    }

    pub fn to_ansi(&self) -> String {
        let (r, g, b) = self.rgb;
        format!("\x1b[38;2;{};{};{}m", r, g, b)
    }
}

pub static horizon_COLORS: &[Color] = &[
    Color::new("van", "#3D5A80", (80, 128, 192)),
    Color::new("agnes", "#8A5070", (234, 116, 117)),
    Color::new("feri", "#F8BA65", (248, 186, 101)),
    Color::new("aaron", "#B84444", (217, 72, 72)),
];

fn main() {
    for color in horizon_COLORS {
        println!("{}{}:{} {}\x1b[0m",
            color.to_ansi(), color.name, color.hex, "████");
    }
}]]
  },
}

local current_sample = 1
local sample_order = { "lua", "python", "rust" }
local typing_speed = 6 -- ms per character
local line_pause = 20   -- ms pause at end of line
local sample_pause = 1000 -- ms pause between samples

-- Global state for cleanup
local active_timer = nil
local should_stop = false

local function stop_demo()
  should_stop = true
  if active_timer then
    pcall(function()
      active_timer:stop()
      active_timer:close()
    end)
    active_timer = nil
  end
  vim.cmd("qa!")
end

-- Keybindings to quit
vim.keymap.set("n", "q", stop_demo, { silent = true })
vim.keymap.set("n", "<Esc>", stop_demo, { silent = true })
vim.keymap.set("n", "<C-c>", stop_demo, { silent = true })

local function type_code(sample)
  if should_stop then return end

  local buf = vim.api.nvim_get_current_buf()

  -- Clear buffer and set filetype
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  vim.bo[buf].filetype = sample.filetype

  -- Scroll to top for new sample
  vim.cmd("normal! gg")

  local lines = vim.split(sample.code, "\n")
  local current_line = 0
  local current_col = 0

  -- Clean up previous timer
  if active_timer then
    pcall(function()
      active_timer:stop()
      active_timer:close()
    end)
  end
  active_timer = vim.loop.new_timer()

  local function type_next_char()
    if should_stop then return end

    if current_line >= #lines then
      if active_timer then
        active_timer:stop()
        active_timer:close()
        active_timer = nil
      end
      -- Schedule next sample
      vim.defer_fn(function()
        if should_stop then return end
        current_sample = current_sample + 1
        if current_sample > #sample_order then
          current_sample = 1
        end
        type_code(code_samples[sample_order[current_sample]])
      end, sample_pause)
      return
    end

    local line = lines[current_line + 1]

    if current_col == 0 then
      -- Start new line
      if current_line == 0 then
        vim.api.nvim_buf_set_lines(buf, 0, 1, false, { "" })
      else
        vim.api.nvim_buf_set_lines(buf, current_line, current_line, false, { "" })
      end
    end

    if current_col < #line then
      -- Type next character
      local char = line:sub(current_col + 1, current_col + 1)
      local current_text = vim.api.nvim_buf_get_lines(buf, current_line, current_line + 1, false)[1] or ""
      vim.api.nvim_buf_set_lines(buf, current_line, current_line + 1, false, { current_text .. char })
      current_col = current_col + 1

      -- Move cursor
      vim.api.nvim_win_set_cursor(0, { current_line + 1, current_col })
    else
      -- End of line, move to next
      current_line = current_line + 1
      current_col = 0

      -- Only scroll if cursor is near bottom of window
      local win_height = vim.api.nvim_win_get_height(0)
      local cursor_row = current_line + 1
      local top_line = vim.fn.line("w0")
      if cursor_row > top_line + win_height - 3 then
        vim.cmd("normal! \x05") -- Ctrl+E to scroll down one line
      end

      -- Longer pause at end of line
      if active_timer then
        active_timer:stop()
      end
      vim.defer_fn(function()
        if should_stop or not active_timer then return end
        active_timer:start(0, typing_speed, vim.schedule_wrap(type_next_char))
      end, line_pause)
      return
    end
  end

  active_timer:start(0, typing_speed, vim.schedule_wrap(type_next_char))
end

-- Start the demo after a short delay
vim.defer_fn(function()
  -- Setup buffer
  vim.cmd("enew")
  vim.wo.number = true
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "yes"
  vim.wo.cursorline = true
  vim.o.showmode = false
  vim.o.cmdheight = 0

  type_code(code_samples[sample_order[current_sample]])
end, 500)
