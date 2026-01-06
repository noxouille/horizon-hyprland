#!/bin/bash

# ============================================================================
# Theme Generator - Create a new theme from horizon template
# ============================================================================
#
# WORKFLOW:
# ---------
# 1. Create a colors SCSS file (e.g., mytheme.scss) with your palette:
#
#    Required variables:
#      - Backgrounds: $bg0 through $bg5 (light-to-dark or dark-to-light)
#      - Foregrounds: $fg0 through $fg5 (contrast scale)
#      - Semantic:    $primary, $secondary, $accent, $warning, $error, $success, $info
#      - Terminal:    $term-black, $term-red, $term-green, $term-yellow,
#                     $term-blue, $term-magenta, $term-cyan, $term-white
#                     (and their $term-bright-* variants)
#
#    Optional (for finer control):
#      - Syntax:      $syntax-keyword, $syntax-function, $syntax-string,
#                     $syntax-constant, $syntax-type, $syntax-property,
#                     $syntax-decorator, $syntax-comment, $syntax-error,
#                     $syntax-warning
#
#    You can also define character-named variables for documentation,
#    but the generator uses semantic roles for mapping.
#
# 2. Run this script:
#      ./generate-theme.sh --name "mytheme" --colors mytheme.scss --output ~/repos/mytheme-hyprland
#
# 3. Test the generated theme:
#      cd ~/repos/mytheme-hyprland
#      ./install.sh
#
# 4. Customize as needed:
#      - Update gallery images in mytheme-gallery/
#      - Edit colors/palette.md documentation
#      - Tweak individual config files if needed
#
# HOW IT WORKS:
# -------------
# The script maps colors by SEMANTIC ROLE, not by variable name.
# This means your theme can use any character/naming convention internally,
# as long as you define the standard semantic variables ($primary, $error, etc.)
#
# Example: horizon's $agnes (coral) is mapped via $secondary.
#          Your theme's $character-name can be anything, as long as
#          you set $secondary to point to it.
#
# ============================================================================
# Usage: ./generate-theme.sh --name "mytheme" --colors my-colors.scss --output ~/repos/mytheme-hyprland
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

success() { echo -e "${GREEN}✓${NC} $1"; }
info() { echo -e "${BLUE}→${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; exit 1; }

# ============================================================================
# Parse arguments
# ============================================================================
THEME_NAME=""
COLORS_FILE=""
OUTPUT_DIR=""
INIT_GIT=true

usage() {
    echo "Usage: $0 --name <theme-name> --colors <colors.scss> --output <directory>"
    echo ""
    echo "Options:"
    echo "  --name, -n     Theme name (lowercase, no spaces)"
    echo "  --colors, -c   Path to your _colors.scss file"
    echo "  --output, -o   Output directory for the new theme"
    echo "  --no-git       Don't initialize a git repository"
    echo ""
    echo "Example:"
    echo "  $0 --name mytheme --colors ~/my-colors.scss --output ~/repos/mytheme-hyprland"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --name|-n)
            THEME_NAME="$2"
            shift 2
            ;;
        --colors|-c)
            COLORS_FILE="$2"
            shift 2
            ;;
        --output|-o)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --no-git)
            INIT_GIT=false
            shift
            ;;
        --help|-h)
            usage
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
done

# Validate arguments
[[ -z "$THEME_NAME" ]] && error "Missing required argument: --name"
[[ -z "$COLORS_FILE" ]] && error "Missing required argument: --colors"
[[ -z "$OUTPUT_DIR" ]] && error "Missing required argument: --output"
[[ ! -f "$COLORS_FILE" ]] && error "Colors file not found: $COLORS_FILE"
[[ -d "$OUTPUT_DIR" ]] && error "Output directory already exists: $OUTPUT_DIR"

# Convert theme name to proper formats
THEME_NAME_LOWER=$(echo "$THEME_NAME" | tr '[:upper:]' '[:lower:]')
THEME_NAME_CAPITALIZED=$(echo "$THEME_NAME" | sed 's/\b\(.\)/\u\1/g')
GTK_THEME_NAME="${THEME_NAME_CAPITALIZED}-BL-MB-Dark"

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                    Theme Generator                               ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
info "Theme name: $THEME_NAME_CAPITALIZED"
info "Colors file: $COLORS_FILE"
info "Output: $OUTPUT_DIR"
echo ""

# ============================================================================
# Extract colors from both SCSS files
# ============================================================================
extract_color() {
    local file="$1"
    local var="$2"
    grep "^\$$var:" "$file" | sed 's/.*: *\(#[0-9A-Fa-f]\{6\}\).*/\1/' | head -1
}

info "Extracting colors from source files..."

# Source colors (horizon)
declare -A SRC_COLORS
while IFS= read -r line; do
    if [[ $line =~ ^\$([a-zA-Z0-9_-]+):\ *(\#[0-9A-Fa-f]{6}) ]]; then
        var="${BASH_REMATCH[1]}"
        color="${BASH_REMATCH[2]}"
        SRC_COLORS["$var"]="$color"
    fi
done < "${SCRIPT_DIR}/colors/_colors.scss"

# Target colors (new theme)
declare -A DST_COLORS
while IFS= read -r line; do
    if [[ $line =~ ^\$([a-zA-Z0-9_-]+):\ *(\#[0-9A-Fa-f]{6}) ]]; then
        var="${BASH_REMATCH[1]}"
        color="${BASH_REMATCH[2]}"
        DST_COLORS["$var"]="$color"
    fi
done < "$COLORS_FILE"

# ============================================================================
# Semantic role mapping - maps horizon roles to new theme equivalents
# ============================================================================
# This allows themes to use different character names while maintaining
# the same semantic meaning. The script maps by ROLE, not by name.
#
# horizon semantic roles (from _colors.scss):
#   $primary   -> main UI color (Van's blue)
#   $secondary -> keywords (Agnès's coral)
#   $accent    -> highlights (Van's blue)
#   $warning   -> warnings (Feri's gold)
#   $error     -> errors (Aaron's red)
#   $success   -> success/strings (Elaine's teal)
#   $info      -> info/types (Risette's sky blue)
#
# New themes should define these semantic variables, and optionally
# $syntax-* variables for more precise control.
# ============================================================================

# Build a mapping from horizon hex values to new theme hex values
# based on semantic roles (primary, secondary, error, etc.)
declare -A SEMANTIC_MAP

# Core semantic mappings - these take priority
semantic_vars=("primary" "secondary" "accent" "warning" "error" "success" "info")
for sem_var in "${semantic_vars[@]}"; do
    src_val="${SRC_COLORS[$sem_var]}"
    dst_val="${DST_COLORS[$sem_var]}"
    if [[ -n "$src_val" && -n "$dst_val" && "$src_val" != "$dst_val" ]]; then
        SEMANTIC_MAP["$src_val"]="$dst_val"
    fi
done

# Syntax highlighting mappings
syntax_vars=("syntax-keyword" "syntax-function" "syntax-string" "syntax-constant"
             "syntax-type" "syntax-property" "syntax-decorator" "syntax-comment"
             "syntax-error" "syntax-warning")
for syn_var in "${syntax_vars[@]}"; do
    src_val="${SRC_COLORS[$syn_var]}"
    dst_val="${DST_COLORS[$syn_var]}"
    if [[ -n "$src_val" && -n "$dst_val" && "$src_val" != "$dst_val" ]]; then
        SEMANTIC_MAP["$src_val"]="$dst_val"
    fi
done

# Terminal color mappings
term_vars=("term-black" "term-red" "term-green" "term-yellow" "term-blue"
           "term-magenta" "term-cyan" "term-white"
           "term-bright-black" "term-bright-red" "term-bright-green"
           "term-bright-yellow" "term-bright-blue" "term-bright-magenta"
           "term-bright-cyan" "term-bright-white")
for term_var in "${term_vars[@]}"; do
    src_val="${SRC_COLORS[$term_var]}"
    dst_val="${DST_COLORS[$term_var]}"
    if [[ -n "$src_val" && -n "$dst_val" && "$src_val" != "$dst_val" ]]; then
        SEMANTIC_MAP["$src_val"]="$dst_val"
    fi
done

# Verify we have the essential base colors (bg0-5, fg0-5)
missing_colors=()
essential_vars=("bg0" "bg1" "bg2" "bg3" "bg4" "bg5" "fg0" "fg1" "fg2" "fg3" "fg4" "fg5")
for var in "${essential_vars[@]}"; do
    if [[ -z "${DST_COLORS[$var]}" ]]; then
        missing_colors+=("$var")
    fi
done

if [[ ${#missing_colors[@]} -gt 0 ]]; then
    warn "Missing essential color definitions in your colors file:"
    for var in "${missing_colors[@]}"; do
        echo "    \$$var: ${SRC_COLORS[$var]}"
    done
    echo ""
    warn "These will keep their original horizon values."
    echo ""
fi

success "Found ${#DST_COLORS[@]} color definitions"
info "Mapped ${#SEMANTIC_MAP[@]} semantic color replacements"

# ============================================================================
# Copy template
# ============================================================================
info "Copying template to $OUTPUT_DIR..."

mkdir -p "$OUTPUT_DIR"

# Copy everything except .git and generated files
cp -r "$SCRIPT_DIR"/* "$OUTPUT_DIR/"
rm -rf "$OUTPUT_DIR/.git" 2>/dev/null || true
rm -f "$OUTPUT_DIR"/*.tar.xz 2>/dev/null || true

success "Template copied"

# ============================================================================
# Replace colors in all files
# ============================================================================
info "Replacing colors..."

# Build sed replacement commands
# We need to track which colors have already been mapped to avoid duplicates
declare -A PROCESSED_COLORS
SED_COMMANDS=""

# First, apply semantic mappings (these take priority)
for src_color in "${!SEMANTIC_MAP[@]}"; do
    dst_color="${SEMANTIC_MAP[$src_color]}"
    PROCESSED_COLORS["$src_color"]=1

    # Case-insensitive replacement for hex colors
    src_upper=$(echo "$src_color" | tr '[:lower:]' '[:upper:]')
    src_lower=$(echo "$src_color" | tr '[:upper:]' '[:lower:]')
    dst_upper=$(echo "$dst_color" | tr '[:lower:]' '[:upper:]')

    # Add both cases
    SED_COMMANDS+="s/${src_upper}/${dst_upper}/gi;"
    SED_COMMANDS+="s/${src_lower}/${dst_upper}/gi;"

    # Also handle without # prefix (for hyprland rgb() format)
    src_no_hash="${src_upper#\#}"
    dst_no_hash="${dst_upper#\#}"
    SED_COMMANDS+="s/rgb(${src_no_hash})/rgb(${dst_no_hash})/gi;"
    SED_COMMANDS+="s/rgba(${src_no_hash}/rgba(${dst_no_hash}/gi;"
done

# Then, apply direct variable name mappings for remaining colors
for var in "${!SRC_COLORS[@]}"; do
    src_color="${SRC_COLORS[$var]}"

    # Skip if already processed via semantic mapping
    [[ -n "${PROCESSED_COLORS[$src_color]}" ]] && continue

    dst_color="${DST_COLORS[$var]:-$src_color}"

    if [[ "$src_color" != "$dst_color" ]]; then
        # Case-insensitive replacement for hex colors
        src_upper=$(echo "$src_color" | tr '[:lower:]' '[:upper:]')
        src_lower=$(echo "$src_color" | tr '[:upper:]' '[:lower:]')
        dst_upper=$(echo "$dst_color" | tr '[:lower:]' '[:upper:]')

        # Add both cases
        SED_COMMANDS+="s/${src_upper}/${dst_upper}/gi;"
        SED_COMMANDS+="s/${src_lower}/${dst_upper}/gi;"

        # Also handle without # prefix (for hyprland rgb() format)
        src_no_hash="${src_upper#\#}"
        dst_no_hash="${dst_upper#\#}"
        SED_COMMANDS+="s/rgb(${src_no_hash})/rgb(${dst_no_hash})/gi;"
        SED_COMMANDS+="s/rgba(${src_no_hash}/rgba(${dst_no_hash}/gi;"
    fi
done

# Apply to all relevant files
find "$OUTPUT_DIR" -type f \( \
    -name "*.scss" -o \
    -name "*.css" -o \
    -name "*.conf" -o \
    -name "*.ini" -o \
    -name "*.rasi" -o \
    -name "*.lua" -o \
    -name "*.json" -o \
    -name "*.md" \
\) -exec sed -i "$SED_COMMANDS" {} \;

success "Colors replaced"

# ============================================================================
# Replace theme names
# ============================================================================
info "Replacing theme names..."

# Replace in files
find "$OUTPUT_DIR" -type f \( \
    -name "*.sh" -o \
    -name "*.lua" -o \
    -name "*.json" -o \
    -name "*.md" -o \
    -name "*.theme" -o \
    -name "*.scss" -o \
    -name "*.css" -o \
    -name "*.conf" \
\) -exec sed -i \
    -e "s/horizon/${THEME_NAME_LOWER}/gi" \
    -e "s/horizon/${THEME_NAME_CAPITALIZED}/g" \
    -e "s/horizon/${THEME_NAME_LOWER^^}/g" \
    {} \;

# Rename directories and files
if [[ -d "$OUTPUT_DIR/horizon-gallery" ]]; then
    mv "$OUTPUT_DIR/horizon-gallery" "$OUTPUT_DIR/${THEME_NAME_LOWER}-gallery"
    # Update python script name
    if [[ -f "$OUTPUT_DIR/${THEME_NAME_LOWER}-gallery/horizon-gallery.py" ]]; then
        mv "$OUTPUT_DIR/${THEME_NAME_LOWER}-gallery/horizon-gallery.py" \
           "$OUTPUT_DIR/${THEME_NAME_LOWER}-gallery/${THEME_NAME_LOWER}-gallery.py"
    fi
fi

if [[ -d "$OUTPUT_DIR/extras/nvim/horizon.nvim" ]]; then
    mv "$OUTPUT_DIR/extras/nvim/horizon.nvim" "$OUTPUT_DIR/extras/nvim/${THEME_NAME_LOWER}.nvim"
    # Rename colors file
    if [[ -f "$OUTPUT_DIR/extras/nvim/${THEME_NAME_LOWER}.nvim/colors/horizon.lua" ]]; then
        mv "$OUTPUT_DIR/extras/nvim/${THEME_NAME_LOWER}.nvim/colors/horizon.lua" \
           "$OUTPUT_DIR/extras/nvim/${THEME_NAME_LOWER}.nvim/colors/${THEME_NAME_LOWER}.lua"
    fi
    # Rename lua module directory
    if [[ -d "$OUTPUT_DIR/extras/nvim/${THEME_NAME_LOWER}.nvim/lua/horizon" ]]; then
        mv "$OUTPUT_DIR/extras/nvim/${THEME_NAME_LOWER}.nvim/lua/horizon" \
           "$OUTPUT_DIR/extras/nvim/${THEME_NAME_LOWER}.nvim/lua/${THEME_NAME_LOWER}"
    fi
fi

if [[ -d "$OUTPUT_DIR/themes/horizon" ]]; then
    mv "$OUTPUT_DIR/themes/horizon" "$OUTPUT_DIR/themes/${THEME_NAME_CAPITALIZED}"
fi

# Rename VSCode theme file
if [[ -f "$OUTPUT_DIR/extras/vscode/horizon-color-theme.json" ]]; then
    mv "$OUTPUT_DIR/extras/vscode/horizon-color-theme.json" \
       "$OUTPUT_DIR/extras/vscode/${THEME_NAME_LOWER}-color-theme.json"
    # Update package.json to reference the new filename
    sed -i "s/horizon-color-theme.json/${THEME_NAME_LOWER}-color-theme.json/g" \
        "$OUTPUT_DIR/extras/vscode/package.json"
fi

# Update install.sh banner text (remove horizon-specific description)
sed -i "s/Inspired by Kuro no Kiseki \/ Trails through Daybreak/A dark theme for Hyprland/" \
    "$OUTPUT_DIR/install.sh"

success "Theme names replaced"

# ============================================================================
# Update new colors file
# ============================================================================
info "Updating colors source file..."
cp "$COLORS_FILE" "$OUTPUT_DIR/colors/_colors.scss"
success "Colors source updated"

# ============================================================================
# Clean up horizon-specific content in README
# ============================================================================
info "Updating README..."

cat > "$OUTPUT_DIR/README.md" << EOF
# ${THEME_NAME_CAPITALIZED} Hyprland Theme

A dark theme for Hyprland and related applications.

## Installation

\`\`\`bash
./install.sh
\`\`\`

Or install all components:

\`\`\`bash
./install.sh --all
\`\`\`

## Components

- **Colorscheme configs**: Hyprland, Kitty, Foot, Rofi, Waybar, GTK4
- **GTK3 theme**: Full GTK3 theme with custom styling
- **Neovim**: Complete colorscheme with Treesitter and LSP support
- **VSCode/VSCodium**: Full editor theme

## Color Palette

See [colors/palette.md](colors/palette.md) for the complete color reference.

---

Generated from [horizon-hyprland](https://github.com/your-username/horizon-hyprland) template.
EOF

success "README updated"

# ============================================================================
# Initialize git repository
# ============================================================================
if $INIT_GIT; then
    info "Initializing git repository..."
    cd "$OUTPUT_DIR"
    git init -q
    git add -A
    git commit -q -m "Initial commit: ${THEME_NAME_CAPITALIZED} theme"
    cd - > /dev/null
    success "Git repository initialized with initial commit"
fi

# ============================================================================
# Done!
# ============================================================================
echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                    Theme Generated!                              ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
success "New theme created at: $OUTPUT_DIR"
echo ""
info "Next steps:"
echo "    1. cd $OUTPUT_DIR"
echo "    2. Review and customize as needed"
echo "    3. Update gallery images in ${THEME_NAME_LOWER}-gallery/ (optional)"
echo "    4. Update colors/palette.md documentation"
echo "    5. Test with: ./install.sh"
echo ""
