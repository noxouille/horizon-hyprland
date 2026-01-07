#!/usr/bin/env python3
"""
Horizon Character Dot Matrix Display
Converts character images to colored ASCII art using their theme colors

Usage: python horizon-gallery.py [portrait|side]
  portrait - Full portrait images (7 characters, row of 3 + row of 4)
  side     - Side profile images (7 characters, row of 3 + row of 4)

Arch Linux: sudo pacman -S python-pillow
"""

from PIL import Image
import sys
import os
import time

# Character color palettes (main color, accent) - enhanced for light theme contrast
PALETTES = {
    'rean': ('#4A423B', '#5A514A'),      # Darker warm brown (PROMINENT)
    'van': ('#1E3A5F', '#2D4A6E'),        # Deeper rich blue (PROMINENT)
    'kevin': ('#2E7D32', '#4A7E2D'),      # More saturated green (PROMINENT)
    'emilia': ('#F57F17', '#F9A825'),     # Vibrant amber/gold
    'agnes': ('#AD1457', '#C2185B'),      # Rich magenta
    'grandmaster': ('#6A1B9A', '#7B1FA2'), # Richer purple
    'aaron': ('#C62828', '#D32F2F'),      # Vibrant red
}

# Darker base for shading (adjusted for light theme)
DARK_BASE = {
    'rean': '#2A2220',
    'van': '#0D1F33',
    'kevin': '#1B5E20',
    'emilia': '#E65100',
    'agnes': '#880E4F',
    'grandmaster': '#4A148C',
    'aaron': '#B71C1C',
}

# Braille base character
BRAILLE_BASE = 0x2800

# Background color from Horizon light theme (bg0 - warm beige from Kai art)
BG_COLOR = (216, 212, 208)  # #D8D4D0

def hex_to_rgb(hex_color):
    """Convert hex to RGB tuple"""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_ansi(r, g, b):
    """Convert RGB to ANSI escape code with background"""
    bg_r, bg_g, bg_b = BG_COLOR
    return f'\033[38;2;{r};{g};{b};48;2;{bg_r};{bg_g};{bg_b}m'

def rgb_to_ansi_bg_only():
    """Return ANSI code for background only (for spaces)"""
    bg_r, bg_g, bg_b = BG_COLOR
    return f'\033[48;2;{bg_r};{bg_g};{bg_b}m'

def lerp_color(color1, color2, t):
    """Linear interpolation between two RGB colors"""
    r1, g1, b1 = color1
    r2, g2, b2 = color2
    return (
        int(r1 + (r2 - r1) * t),
        int(g1 + (g2 - g1) * t),
        int(b1 + (b2 - b1) * t)
    )

def image_to_halfblock(image_path, width=30, height=30, character='van'):
    """Convert image to colored half-block characters for light theme visibility"""
    img = Image.open(image_path).convert('RGBA')

    # Half-block: each character represents 2 vertical pixels
    pixel_width = width
    pixel_height = height * 2
    img = img.resize((pixel_width, pixel_height), Image.Resampling.LANCZOS)

    # Get palette colors
    dark_color = hex_to_rgb(DARK_BASE.get(character, '#151a20'))
    main_color = hex_to_rgb(PALETTES[character][0])
    bright_color = hex_to_rgb(PALETTES[character][1])

    result = []

    # Half-block characters
    UPPER_HALF = '▀'  # Upper half block
    LOWER_HALF = '▄'  # Lower half block
    FULL_BLOCK = '█'  # Full block

    for by in range(height):
        line = ''
        for bx in range(width):
            # Get top and bottom pixels for this character cell
            top_y = by * 2
            bot_y = by * 2 + 1

            # Get pixel data
            top_r, top_g, top_b, top_a = img.getpixel((bx, top_y))
            bot_r, bot_g, bot_b, bot_a = img.getpixel((bx, bot_y)) if bot_y < pixel_height else (0, 0, 0, 0)

            top_visible = top_a > 30
            bot_visible = bot_a > 30

            if not top_visible and not bot_visible:
                # Both transparent - show background
                line += f'\033[48;2;{BG_COLOR[0]};{BG_COLOR[1]};{BG_COLOR[2]}m '
                continue

            # Calculate brightness for color mapping
            top_brightness = (top_r + top_g + top_b) / (255 * 3) if top_visible else 0
            bot_brightness = (bot_r + bot_g + bot_b) / (255 * 3) if bot_visible else 0

            def get_color(brightness):
                """Map brightness to character palette color"""
                if brightness < 0.3:
                    return lerp_color(dark_color, main_color, brightness / 0.3)
                else:
                    return lerp_color(main_color, bright_color, (brightness - 0.3) / 0.7)

            if top_visible and bot_visible:
                # Both pixels visible
                top_color = get_color(top_brightness)
                bot_color = get_color(bot_brightness)

                # Use upper half block with foreground=top, background=bottom
                line += f'\033[38;2;{top_color[0]};{top_color[1]};{top_color[2]};48;2;{bot_color[0]};{bot_color[1]};{bot_color[2]}m{UPPER_HALF}'

            elif top_visible:
                # Only top pixel visible
                top_color = get_color(top_brightness)
                line += f'\033[38;2;{top_color[0]};{top_color[1]};{top_color[2]};48;2;{BG_COLOR[0]};{BG_COLOR[1]};{BG_COLOR[2]}m{UPPER_HALF}'

            else:
                # Only bottom pixel visible
                bot_color = get_color(bot_brightness)
                line += f'\033[38;2;{bot_color[0]};{bot_color[1]};{bot_color[2]};48;2;{BG_COLOR[0]};{BG_COLOR[1]};{BG_COLOR[2]}m{LOWER_HALF}'

        result.append(line + '\033[0m')

    return result


def image_to_braille(image_path, width=30, height=15, character='van'):
    """Wrapper that calls half-block version for light theme"""
    return image_to_halfblock(image_path, width, height, character)

def get_visible_chars(line):
    """Extract visible characters from a line with ANSI codes, preserving codes"""
    chars = []  # List of (ansi_prefix, char) tuples
    current_ansi = ''
    in_escape = False
    escape_seq = ''

    for c in line:
        if c == '\033':
            in_escape = True
            escape_seq = c
        elif in_escape:
            escape_seq += c
            if c == 'm':
                in_escape = False
                current_ansi = escape_seq
                escape_seq = ''
        else:
            chars.append((current_ansi, c))

    return chars

def print_side_by_side(arts, names, char_width=24, spacing=0, animate=True, delay=0.008):
    """Print multiple ASCII arts side by side with optional character-by-character animation"""
    if not arts:
        return

    bg_ansi = rgb_to_ansi_bg_only()
    max_height = max(len(art) for art in arts)

    # Build all lines first
    all_lines = []
    for row in range(max_height):
        line_parts = []
        for i, art in enumerate(arts):
            art_line = art[row] if row < len(art) else ''
            # Calculate visible length (without ANSI codes)
            visible_len = 0
            in_escape = False
            for c in art_line:
                if c == '\033':
                    in_escape = True
                elif in_escape and c == 'm':
                    in_escape = False
                elif not in_escape:
                    visible_len += 1
            # Pad to width
            padding = char_width - visible_len
            line_parts.append(art_line + bg_ansi + ' ' * max(0, padding))
        all_lines.append(bg_ansi + (' ' * spacing).join(line_parts) + '\033[0m')

    # Build name line
    name_parts = []
    for name in names:
        color = hex_to_rgb(PALETTES[name][0])
        ansi = rgb_to_ansi(*color)
        padded_name = name.upper().center(char_width)
        name_parts.append(ansi + padded_name + '\033[0m')
    name_line = bg_ansi + (' ' * spacing).join(name_parts) + '\033[0m'

    if not animate:
        for line in all_lines:
            print(line)
        print(name_line)
        return

    # Animate character by character
    # First, parse all lines into visible characters
    parsed_lines = [get_visible_chars(line) for line in all_lines]
    parsed_name = get_visible_chars(name_line)

    # Find max width
    max_width = max(len(chars) for chars in parsed_lines) if parsed_lines else 0
    max_width = max(max_width, len(parsed_name))

    # Print empty lines first to reserve space
    num_lines = len(all_lines) + 1  # +1 for name line
    for _ in range(num_lines):
        print(bg_ansi + ' ' * max_width + '\033[0m')

    # Move cursor back up to start of our block
    print(f'\033[{num_lines}A', end='', flush=True)

    # Reveal column by column
    for col in range(max_width):
        # Save cursor position at start of block
        print('\033[s', end='')

        for row, chars in enumerate(parsed_lines):
            # Move to start of line, print content up to col
            print('\r', end='')
            output = bg_ansi
            for i in range(col + 1):
                if i < len(chars):
                    ansi, char = chars[i]
                    output += ansi + char
            print(output + '\033[0m', end='')
            # Move down one line
            if row < len(parsed_lines) - 1:
                print('\033[1B', end='')

        # Name line (move down and print)
        print('\033[1B\r', end='')
        output = bg_ansi
        for i in range(col + 1):
            if i < len(parsed_name):
                ansi, char = parsed_name[i]
                output += ansi + char
        print(output + '\033[0m', end='', flush=True)

        # Restore cursor to top of block for next iteration
        print('\033[u', end='', flush=True)

        time.sleep(delay)

    # Move cursor below the content
    print(f'\033[{num_lines}B', end='')

def main():
    # Parse command line argument
    mode = 'portrait'  # default
    if len(sys.argv) > 1:
        arg = sys.argv[1].lower()
        if arg in ('portrait', 'side'):
            mode = arg
        else:
            print(f"Usage: {sys.argv[0]} [portrait|side]")
            sys.exit(1)

    # Get script directory for relative paths
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Set background color (bg0 from Horizon theme: #13171d)
    bg_ansi = rgb_to_ansi_bg_only()
    print(bg_ansi + '\033[2J\033[H')  # Clear screen with background

    # Simple header (colors for light theme)
    VAN = '\033[38;2;30;58;95m'      # #1E3A5F - deeper blue for light bg
    FG4 = '\033[38;2;90;88;86m'      # #5A5856 - darker gray for light bg
    RESET = '\033[0m'

    print(bg_ansi + VAN + '  Horizon Theme' + FG4 + ' - Character Gallery' + RESET)
    print(bg_ansi)

    if mode == 'portrait':
        # Portrait mode: 7 characters in 1 row
        characters = [
            ('rean', 'portrait/rean.webp'),
            ('van', 'portrait/van.webp'),
            ('kevin', 'portrait/kevin.webp'),
            ('emilia', 'portrait/emilia.webp'),
            ('agnes', 'portrait/agnes.webp'),
            ('grandmaster', 'portrait/grandmaster.webp'),
            ('aaron', 'portrait/aaron.webp'),
        ]
        CHAR_WIDTH = 26
        CHAR_HEIGHT = 26
        rows = [(0, 7)]
    else:
        # Side mode: 7 characters in 1 row
        characters = [
            ('rean', 'side/rean.webp'),
            ('van', 'side/van.webp'),
            ('kevin', 'side/kevin.webp'),
            ('emilia', 'side/emilia.webp'),
            ('agnes', 'side/agnes.webp'),
            ('grandmaster', 'side/grandmaster.webp'),
            ('aaron', 'side/aaron.webp'),
        ]
        CHAR_WIDTH = 26
        CHAR_HEIGHT = 26
        rows = [(0, 7)]

    # Convert all images
    arts = []
    names = []
    for name, path in characters:
        try:
            full_path = os.path.join(script_dir, path)
            art = image_to_braille(full_path, width=CHAR_WIDTH, height=CHAR_HEIGHT, character=name)
            arts.append(art)
            names.append(name)
        except Exception as e:
            print(f"Error processing {name}: {e}")

    # Hide cursor during animation
    print('\033[?25l', end='')

    try:
        # Print in rows with animation
        for start, end in rows:
            print_side_by_side(arts[start:end], names[start:end], CHAR_WIDTH, animate=True, delay=0.006)
            print(bg_ansi + '\033[0m')
    finally:
        # Show cursor again
        print('\033[?25h', end='')

    print('\033[0m')  # Reset terminal at end

if __name__ == '__main__':
    main()
