#!/bin/bash

# ============================================================================
# horizon Hyprland Theme - Installation Script
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_NAME="horizon"
GTK_THEME_NAME="horizon-BL-MB-Dark"

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║           horizon Hyprland Theme - Installation                  ║"
echo "║      A dark theme for Hyprland        ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() { echo -e "${GREEN}✓${NC} $1"; }
info() { echo -e "${BLUE}→${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }

# ============================================================================
# Config files → ~/.config/colorschemes/horizon/
# ============================================================================
install_colorscheme() {
  info "Installing colorscheme to ~/.config/colorschemes/${THEME_NAME}/"

  mkdir -p ~/.config/colorschemes/${THEME_NAME}

  # Copy all config files
  cp -r "${SCRIPT_DIR}/config/"* ~/.config/colorschemes/${THEME_NAME}/
  cp -r "${SCRIPT_DIR}/colors" ~/.config/colorschemes/${THEME_NAME}/

  # Make scripts executable
  chmod +x ~/.config/colorschemes/${THEME_NAME}/scripts/*.sh 2>/dev/null || true

  success "Colorscheme installed to ~/.config/colorschemes/${THEME_NAME}/"
  echo ""
  info "Link or source files from ~/.config/colorschemes/${THEME_NAME}/"
  echo ""
  echo "  Hyprland:  source = ~/.config/colorschemes/${THEME_NAME}/hyprland.conf"
  echo "  Kitty:     include ~/.config/colorschemes/${THEME_NAME}/kittyconf"
  echo "  Foot:      include=~/.config/colorschemes/${THEME_NAME}/foot.ini"
  echo "  Rofi:      @theme \"~/.config/colorschemes/${THEME_NAME}/rofi.rasi\""
  echo "  Waybar:    @import \"../../colorschemes/${THEME_NAME}/colors.css\";"
  echo "  GTK4:      cp ~/.config/colorschemes/${THEME_NAME}/gtk-4.0/gtk.css ~/.config/gtk-4.0/"
  echo ""
  info "Showcase scripts installed to ~/.config/colorschemes/${THEME_NAME}/scripts/"
  echo "  Configure music: Edit ~/.config/colorschemes/${THEME_NAME}/showcase.conf"
  echo "  Run showcase:    ~/.config/colorschemes/${THEME_NAME}/scripts/showcase.sh"
  echo "  Toggle music:    ~/.config/colorschemes/${THEME_NAME}/scripts/toggle-music.sh"
  echo "  Typing demo:     nvim -u NONE -c 'luafile ~/.config/colorschemes/${THEME_NAME}/scripts/typing-demo.lua'"
}

# ============================================================================
# GTK Theme → ~/.themes/horizon-BL-MB-Dark/
# ============================================================================
install_gtk() {
  info "Installing GTK theme to ~/.themes/${GTK_THEME_NAME}/"

  mkdir -p ~/.themes/${GTK_THEME_NAME}/gtk-3.0

  # Copy GTK3 theme files
  cp "${SCRIPT_DIR}/themes/horizon/index.theme" ~/.themes/${GTK_THEME_NAME}/
  cp "${SCRIPT_DIR}/themes/horizon/gtk-3.0/gtk.css" ~/.themes/${GTK_THEME_NAME}/gtk-3.0/

  # Update index.theme with correct name
  sed -i "s/Name=horizon/Name=${GTK_THEME_NAME}/" ~/.themes/${GTK_THEME_NAME}/index.theme
  sed -i "s/GtkTheme=horizon/GtkTheme=${GTK_THEME_NAME}/" ~/.themes/${GTK_THEME_NAME}/index.theme
  sed -i "s/MetacityTheme=horizon/MetacityTheme=${GTK_THEME_NAME}/" ~/.themes/${GTK_THEME_NAME}/index.theme

  success "GTK3 theme installed to ~/.themes/${GTK_THEME_NAME}/"
  echo ""
  info "Apply with: nwg-look or gsettings set org.gnome.desktop.interface gtk-theme '${GTK_THEME_NAME}'"
}

# ============================================================================
# horizon Gallery → ~/.local/share/horizon-gallery/
# ============================================================================
install_gallery() {
  info "Installing horizon Gallery..."

  mkdir -p ~/.local/share/horizon-gallery

  # Remove old installation if exists
  rm -rf ~/.local/share/horizon-gallery/*

  # Copy gallery files
  cp -r "${SCRIPT_DIR}/horizon-gallery/"* ~/.local/share/horizon-gallery/

  success "horizon Gallery installed to ~/.local/share/horizon-gallery/"
  echo ""
  info "Usage: python ~/.local/share/horizon-gallery/horizon-gallery.py [portrait|side]"
}

# ============================================================================
# Neovim → ~/.local/share/nvim/themes/horizon.nvim/
# ============================================================================
install_nvim() {
  info "Installing Neovim colorscheme..."

  mkdir -p ~/.local/share/nvim/themes

  # Remove old installation if exists
  rm -rf ~/.local/share/nvim/themes/horizon.nvim

  # Copy neovim theme
  cp -r "${SCRIPT_DIR}/extras/nvim/horizon.nvim" ~/.local/share/nvim/themes/

  success "Neovim theme installed to ~/.local/share/nvim/themes/horizon.nvim/"
  echo ""
  info "Add to ~/.config/nvim/lua/plugins/colorscheme.lua:"
  echo ""
  echo '  {'
  echo '    dir = "~/.local/share/nvim/themes/horizon.nvim",'
  echo '    name = "horizon",'
  echo '    lazy = false,'
  echo '    priority = 1000,'
  echo '  },'
  echo '  {'
  echo '    "LazyVim/LazyVim",'
  echo '    opts = { colorscheme = "horizon" },'
  echo '  },'
}

# ============================================================================
# VSCodium → Install via VSIX
# ============================================================================
install_vscode() {
  info "Installing VSCodium theme..."

  # Create VSIX package
  mkdir -p /tmp/horizon-vsix/extension
  cp "${SCRIPT_DIR}/extras/vscode/package.json" /tmp/horizon-vsix/extension/
  cp "${SCRIPT_DIR}/extras/vscode/horizon-color-theme.json" /tmp/horizon-vsix/extension/

  cd /tmp/horizon-vsix
  zip -r /tmp/horizon-theme.vsix extension >/dev/null
  cd - >/dev/null
  rm -rf /tmp/horizon-vsix

  # Try to install
  if command -v codium &>/dev/null; then
    codium --install-extension /tmp/horizon-theme.vsix
    success "VSCodium theme installed!"
    info "Activate: Ctrl+K Ctrl+T → Select 'horizon'"
  elif command -v code &>/dev/null; then
    code --install-extension /tmp/horizon-theme.vsix
    success "VS Code theme installed!"
    info "Activate: Ctrl+K Ctrl+T → Select 'horizon'"
  else
    success "VSIX package created at /tmp/horizon-theme.vsix"
    info "Install manually: codium --install-extension /tmp/horizon-theme.vsix"
  fi

  rm -f /tmp/horizon-theme.vsix
}

# ============================================================================
# Install All
# ============================================================================
install_all() {
  install_colorscheme
  echo ""
  install_gtk
  echo ""
  install_gallery
  echo ""
  install_nvim
  echo ""
  install_vscode
}

# ============================================================================
# Menu
# ============================================================================
show_menu() {
  echo "What would you like to install?"
  echo ""
  echo "  1) All components"
  echo "  2) Colorscheme configs only (~/.config/colorschemes/${THEME_NAME}/)"
  echo "  3) GTK theme only (~/.themes/${GTK_THEME_NAME}/)"
  echo "  4) horizon Gallery (~/.local/share/horizon-gallery/)"
  echo "  5) Neovim colorscheme"
  echo "  6) VSCodium/VS Code theme"
  echo "  0) Exit"
  echo ""
  read -p "Choice [0-6]: " choice

  case $choice in
  1) install_all ;;
  2) install_colorscheme ;;
  3) install_gtk ;;
  4) install_gallery ;;
  5) install_nvim ;;
  6) install_vscode ;;
  0)
    echo "Bye!"
    exit 0
    ;;
  *)
    echo "Invalid choice"
    show_menu
    ;;
  esac
}

# ============================================================================
# Main
# ============================================================================
if [ "$1" == "--all" ]; then
  install_all
else
  show_menu
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                    Installation Complete!                        ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
