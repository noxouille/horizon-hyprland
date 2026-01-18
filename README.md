# Horizon Hyprland Theme

> **Disclaimer:** This software is provided "as is", without warranty of any kind. Use at your own risk. The author is not responsible for any damage, data loss, or issues that may arise from using this theme or running the install scripts. Always review scripts before executing them and back up your configurations.

A light theme for Hyprland inspired by **Kai no Kiseki / Trails beyond the Horizon**, featuring colors based on crossover protagonists and artifacts.

## Color Palette

| Character | Hex | Usage |
|-----------|-----|-------|
| **Van Arkride** | `#1E3A5F` | Primary, functions |
| **Kevin Graham** | `#2E7D32` | Strings, success |
| **Rean Schwarzer** | `#4A423B` | Properties |
| **Agnès Claudel** | `#AD1457` | Keywords |
| **Emilia** | `#704700` | Constants |
| **Grandmaster** | `#6A1B9A` | Decorators |
| **Laegjarn's Chest** | `#005A4F` | Types, info |
| **Horizon** | `#BF4400` | Warnings |
| **Aaron Wei** | `#C62828` | Errors |

## Structure

```
horizon-hyprland/
├── colors/                   # Color reference
│   └── palette.md
│
├── config/                   # → ~/.config/colorschemes/horizon/
│   ├── colors.css              # Shared colors (Waybar, wlogout, SwayNC)
│   ├── foot.ini
│   ├── gtk-4.0/gtk.css
│   ├── gtk-theme               # GTK theme name for gsettings
│   ├── hyprland.conf
│   ├── kitty.conf
│   ├── logo.png                # Fastfetch logo
│   ├── matugen-base.json       # Base colors for matugen/walset wallpaper picker
│   ├── nvim-theme
│   ├── rofi.rasi
│   ├── scripts/
│   │   └── typing-demo.lua
│   ├── showcase.conf
│   ├── vscodium-theme
│   ├── wallpaper-default       # Default wallpaper path (relative to ~/Pictures/Wallpapers/)
│   ├── wallpaper.jpg           # Fallback/sample wallpaper
│   ├── wallpapers              # List of compatible wallpapers for walset picker
│   └── waybar-layout           # Default waybar layout for this theme
│
├── extras/                   # Installed separately
│   ├── nvim/horizon.nvim/
│   │   ├── colors/horizon.lua
│   │   └── lua/horizon/
│   └── vscode/
│
├── horizon-gallery/          # Character images
│
├── themes/                   # → ~/.themes/
│   └── Horizon/
│       ├── index.theme
│       └── gtk-3.0/gtk.css
│
├── install.sh
└── README.md
```

## Installation

### Quick Install

```bash
git clone https://github.com/noxouille/horizon-hyprland
cd horizon-hyprland
./install.sh --all
```

### Manual Install

**Config files** (symlinked to `~/.config/`):
```bash
./install.sh
# Select option 2
```

**GTK theme** (symlinked to `~/.themes/`):
```bash
./install.sh
# Select option 3
```

## Usage

### Hyprland
Add to `~/.config/hypr/hyprland.conf`:
```bash
source = ~/.config/hyprland/colors.conf
```

### Kitty
Add to `~/.config/kitty/kitty.conf`:
```bash
include horizon.conf
```

### Foot
Add to `~/.config/foot/foot.ini`:
```ini
include=~/.config/foot/horizon.ini
```

### Rofi
Add to `~/.config/rofi/config.rasi`:
```
@theme "horizon"
```

### Waybar
Add to your `style.css`:
```css
@import "colors.css";
```

The `waybar-layout` file specifies the default waybar layout when switching to this theme.

### Wallpapers

The theme includes wallpaper integration with the `walset` wallpaper picker:

- **`wallpaper-default`** - Path to the default wallpaper (relative to `~/Pictures/Wallpapers/`). Applied automatically when switching to this theme via `apply-theme.sh`.

- **`wallpapers`** - List of compatible wallpapers for the theme. When this file exists, the `walset` picker will only show wallpapers from this list. Supports:
  - Individual files: `Trails/horizon/cal-w2408-m.jpg`
  - Glob patterns: `Trails/horizon/*`
  - Comments: Lines starting with `#`

- **`matugen-base.json`** - Base colors for [matugen](https://github.com/InioX/matugen). Required for `walset` to work properly. Defines custom color variables (bg, fg, color0-15) that matugen templates use alongside wallpaper-extracted accent colors.

If `wallpapers` file doesn't exist, all wallpapers in `~/Pictures/Wallpapers/` are available.

### GTK Theme
```bash
# Using nwg-look
nwg-look
# Select "Horizon"

# Or gsettings
gsettings set org.gnome.desktop.interface gtk-theme 'Horizon'
```

### Neovim (LazyVim)
Add to `~/.config/nvim/lua/plugins/colorscheme.lua`:
```lua
return {
  {
    dir = "~/.local/share/nvim/themes/horizon.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "horizon" },
  },
}
```

### VSCodium
```bash
./install.sh
# Select option 5
codium --install-extension ~/horizon-theme.vsix
```
Then `Ctrl+K Ctrl+T` → Select "Horizon"

## Credits

- Inspired by [Trails beyond the Horizon](https://kiseki.fandom.com/wiki/The_Legend_of_Heroes:_Kai_no_Kiseki_-_Farewell,_O_Zemuria)

## License

MIT
