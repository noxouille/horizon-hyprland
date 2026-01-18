#!/usr/bin/env python3
"""
Horizon Character Dot Matrix Display
Converts character images to colored braille art using their theme colors

Usage: python horizon-gallery.py [portrait|side]
  portrait - Full portrait images (3 characters: Rean, Van, Kevin)
  side     - Side profile images (3 characters)

Arch Linux: sudo pacman -S python-pillow
"""

from PIL import Image
import sys
import os
import time

# Character color palettes - MORE SATURATED for light theme visibility
PALETTES = {
    'rean': ('#5C4033', '#8B6914'),      # Rich brown / bronze
    'van': ('#0A4D8C', '#1565C0'),        # Bold blue
    'kevin': ('#1B6B1B', '#2E8B2E'),      # Rich forest green
    'emilia': ('#E65100', '#FF8F00'),     # Bold orange/amber
    'agnes': ('#AD1457', '#D81B60'),      # Hot pink/magenta
    'grandmaster': ('#6A1B9A', '#8E24AA'), # Bold purple
    'aaron': ('#B71C1C', '#E53935'),      # Bold red
}

# Darker base for shading - even darker for contrast
DARK_BASE = {
    'rean': '#2E1F1A',
    'van': '#051E3E',
    'kevin': '#0D3D0D',
    'emilia': '#7A2900',
    'agnes': '#5C0A2F',
    'grandmaster': '#3A0A5C',
    'aaron': '#6B0F0F',
}

# Braille base character
BRAILLE_BASE = 0x2800

# Background color from Horizon light theme (bg0 - warm beige)
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


def image_to_braille(image_path, width=30, height=15, character='van', upper_crop=1.0):
    """Convert image to colored braille dot matrix with density variation"""
    img = Image.open(image_path).convert('RGBA')

    # Crop to upper portion if specified
    if upper_crop < 1.0:
        orig_width, orig_height = img.size
        crop_height = int(orig_height * upper_crop)
        img = img.crop((0, 0, orig_width, crop_height))

    # Braille is 2x4 dots per character
    pixel_width = width * 2
    pixel_height = height * 4
    img = img.resize((pixel_width, pixel_height), Image.Resampling.LANCZOS)

    # Get palette colors
    dark_color = hex_to_rgb(DARK_BASE.get(character, '#151a20'))
    main_color = hex_to_rgb(PALETTES[character][0])
    bright_color = hex_to_rgb(PALETTES[character][1])

    result = []
    bg_ansi = rgb_to_ansi_bg_only()

    # Braille dot positions (column-major order):
    # 0 3
    # 1 4
    # 2 5
    # 6 7
    dot_map = [
        (0, 0, 0x01), (0, 1, 0x02), (0, 2, 0x04), (0, 3, 0x40),
        (1, 0, 0x08), (1, 1, 0x10), (1, 2, 0x20), (1, 3, 0x80)
    ]

    for by in range(height):
        line = ''
        for bx in range(width):
            px, py = bx * 2, by * 4

            # Collect brightness values for each dot position
            dot_brightness = []
            total_brightness = 0
            visible = 0

            for dx, dy, bit in dot_map:
                x, y = px + dx, py + dy
                if x < pixel_width and y < pixel_height:
                    r, g, b, a = img.getpixel((x, y))
                    if a > 30:
                        brightness = (r + g + b) / (255 * 3)
                        dot_brightness.append((bit, brightness))
                        total_brightness += brightness
                        visible += 1
                    else:
                        dot_brightness.append((bit, 0))
                else:
                    dot_brightness.append((bit, 0))

            if visible == 0:
                line += bg_ansi + ' '
                continue

            avg_brightness = total_brightness / visible

            # For light theme, we want to show darker areas more prominently
            # Invert the logic - darker pixels = more dots
            darkness = 1.0 - avg_brightness

            # Skip very light cells (they blend with background)
            if darkness < 0.10:
                line += bg_ansi + ' '
                continue

            # Determine how many dots to show based on darkness
            if darkness < 0.15:
                num_dots = 1
            elif darkness < 0.25:
                num_dots = 2
            elif darkness < 0.35:
                num_dots = 3
            elif darkness < 0.45:
                num_dots = 4
            elif darkness < 0.55:
                num_dots = 5
            elif darkness < 0.65:
                num_dots = 6
            elif darkness < 0.75:
                num_dots = 7
            else:
                num_dots = 8

            # Sort dots by darkness (1-brightness) and pick the darkest ones
            dot_brightness.sort(key=lambda x: (1.0 - x[1]) if x[1] > 0 else 0, reverse=True)

            dots = 0
            for i, (bit, br) in enumerate(dot_brightness):
                if i < num_dots and br > 0:
                    dots |= bit

            if dots == 0:
                line += bg_ansi + ' '
            else:
                # Color based on darkness level - darker = richer color
                if darkness < 0.4:
                    color = lerp_color(bright_color, main_color, darkness / 0.4)
                else:
                    color = lerp_color(main_color, dark_color, (darkness - 0.4) / 0.6)

                line += rgb_to_ansi(*color) + chr(BRAILLE_BASE + dots)

        result.append(line + '\033[0m')

    return result


def get_visible_chars(line):
    """Extract visible characters from a line with ANSI codes, preserving codes"""
    chars = []
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


def print_side_by_side(arts, names, char_width=24, spacing=2, animate=True, delay=0.008):
    """Print multiple ASCII arts side by side with optional animation"""
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
            visible_len = 0
            in_escape = False
            for c in art_line:
                if c == '\033':
                    in_escape = True
                elif in_escape and c == 'm':
                    in_escape = False
                elif not in_escape:
                    visible_len += 1
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
    parsed_lines = [get_visible_chars(line) for line in all_lines]
    parsed_name = get_visible_chars(name_line)

    max_width = max(len(chars) for chars in parsed_lines) if parsed_lines else 0
    max_width = max(max_width, len(parsed_name))

    num_lines = len(all_lines) + 1
    for _ in range(num_lines):
        print(bg_ansi + ' ' * max_width + '\033[0m')

    print(f'\033[{num_lines}A', end='', flush=True)

    for col in range(max_width):
        print('\033[s', end='')

        for row, chars in enumerate(parsed_lines):
            print('\r', end='')
            output = bg_ansi
            for i in range(col + 1):
                if i < len(chars):
                    ansi, char = chars[i]
                    output += ansi + char
            print(output + '\033[0m', end='')
            if row < len(parsed_lines) - 1:
                print('\033[1B', end='')

        print('\033[1B\r', end='')
        output = bg_ansi
        for i in range(col + 1):
            if i < len(parsed_name):
                ansi, char = parsed_name[i]
                output += ansi + char
        print(output + '\033[0m', end='', flush=True)

        print('\033[u', end='', flush=True)
        time.sleep(delay)

    print(f'\033[{num_lines}B', end='')


def print_vertical(art, name, char_width, animate=True, delay=0.005):
    """Print a single character art with name, optionally animated"""
    bg_ansi = rgb_to_ansi_bg_only()

    # Build name line
    color = hex_to_rgb(PALETTES[name][0])
    ansi = rgb_to_ansi(*color)
    name_line = bg_ansi + ansi + name.upper().center(char_width) + '\033[0m'

    if not animate:
        for line in art:
            print(line)
        print(name_line)
        return

    # Animate
    parsed_lines = [get_visible_chars(line) for line in art]
    parsed_name = get_visible_chars(name_line)

    max_width = max(len(chars) for chars in parsed_lines) if parsed_lines else 0
    max_width = max(max_width, len(parsed_name))

    num_lines = len(art) + 1
    for _ in range(num_lines):
        print(bg_ansi + ' ' * max_width + '\033[0m')

    print(f'\033[{num_lines}A', end='', flush=True)

    for col in range(max_width):
        print('\033[s', end='')

        for row, chars in enumerate(parsed_lines):
            print('\r', end='')
            output = bg_ansi
            for i in range(col + 1):
                if i < len(chars):
                    ansi_code, char = chars[i]
                    output += ansi_code + char
            print(output + '\033[0m', end='')
            if row < len(parsed_lines) - 1:
                print('\033[1B', end='')

        print('\033[1B\r', end='')
        output = bg_ansi
        for i in range(col + 1):
            if i < len(parsed_name):
                ansi_code, char = parsed_name[i]
                output += ansi_code + char
        print(output + '\033[0m', end='', flush=True)

        print('\033[u', end='', flush=True)
        time.sleep(delay)

    print(f'\033[{num_lines}B', end='')


def main():
    mode = 'portrait'
    if len(sys.argv) > 1:
        arg = sys.argv[1].lower()
        if arg in ('portrait', 'side'):
            mode = arg
        else:
            print(f"Usage: {sys.argv[0]} [portrait|side]")
            sys.exit(1)

    script_dir = os.path.dirname(os.path.abspath(__file__))

    bg_ansi = rgb_to_ansi_bg_only()
    print(bg_ansi + '\033[2J\033[H')

    # Header
    VAN = '\033[38;2;30;58;95m'
    FG4 = '\033[38;2;90;88;86m'
    RESET = '\033[0m'

    print(bg_ansi + VAN + '  Horizon Theme' + FG4 + ' - Character Gallery' + RESET)
    print(bg_ansi)

    if mode == 'portrait':
        # 3 protagonists stacked vertically, wider for recognizability
        characters = [
            ('rean', 'portrait/rean.webp'),
            ('van', 'portrait/van.webp'),
            ('kevin', 'portrait/kevin.webp'),
        ]
        CHAR_WIDTH = 60
        CHAR_HEIGHT = 12  # Compact to fit 3 in window without scrolling
        UPPER_CROP = 0.50  # Face focus (top 50%)
    else:
        characters = [
            ('van', 'side/van.webp'),
            ('agnes', 'side/agnes.webp'),
            ('aaron', 'side/aaron.webp'),
        ]
        CHAR_WIDTH = 60
        CHAR_HEIGHT = 8
        UPPER_CROP = 0.60

    print('\033[?25l', end='')

    try:
        for name, path in characters:
            try:
                full_path = os.path.join(script_dir, path)
                art = image_to_braille(full_path, width=CHAR_WIDTH, height=CHAR_HEIGHT,
                                       character=name, upper_crop=UPPER_CROP)
                print_vertical(art, name, CHAR_WIDTH, animate=True, delay=0.003)
                print(bg_ansi)
            except Exception as e:
                print(f"Error processing {name}: {e}")
    finally:
        print('\033[?25h', end='')

    print('\033[0m')


if __name__ == '__main__':
    main()