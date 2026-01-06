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

# Character color palettes (main color, accent) - from _colors.scss
PALETTES = {
    'rean': ('#6B6259', '#7D746A'),
    'van': ('#3D5A80', '#4E6D94'),
    'kevin': ('#6A9E3D', '#7DB34E'),
    'emilia': ('#9A8C40', '#ADA050'),
    'agnes': ('#8A5070', '#9D6283'),
    'grandmaster': ('#9B7BC4', '#AE8ED5'),
    'aaron': ('#B84444', '#CC5858'),
}

# Darker base for shading
DARK_BASE = {
    'rean': '#1a1815',
    'van': '#101820',
    'kevin': '#152010',
    'emilia': '#201c10',
    'agnes': '#1a1018',
    'grandmaster': '#181028',
    'aaron': '#201010',
}

# Braille base character
BRAILLE_BASE = 0x2800

# Background color from Horizon theme (bg0)
BG_COLOR = (19, 23, 29)  # #13171d

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

def image_to_braille(image_path, width=30, height=15, character='van'):
    """Convert image to colored braille dot matrix with density variation"""
    img = Image.open(image_path).convert('RGBA')

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

            # Skip very dark cells
            if avg_brightness < 0.15:
                line += bg_ansi + ' '
                continue

            # Determine how many dots to show based on average brightness
            if avg_brightness < 0.25:
                num_dots = 1
            elif avg_brightness < 0.35:
                num_dots = 2
            elif avg_brightness < 0.45:
                num_dots = 3
            elif avg_brightness < 0.55:
                num_dots = 4
            elif avg_brightness < 0.65:
                num_dots = 5
            elif avg_brightness < 0.75:
                num_dots = 6
            elif avg_brightness < 0.85:
                num_dots = 7
            else:
                num_dots = 8

            # Sort dots by brightness and pick the brightest ones
            dot_brightness.sort(key=lambda x: x[1], reverse=True)

            dots = 0
            for i, (bit, br) in enumerate(dot_brightness):
                if i < num_dots and br > 0.1:
                    dots |= bit

            if dots == 0:
                line += bg_ansi + ' '
            else:
                # Color based on brightness
                if avg_brightness < 0.4:
                    color = lerp_color(dark_color, main_color, avg_brightness / 0.4)
                else:
                    color = lerp_color(main_color, bright_color, (avg_brightness - 0.4) / 0.6)

                line += rgb_to_ansi(*color) + chr(BRAILLE_BASE + dots)

        result.append(line + '\033[0m')

    return result

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

    # Simple header
    VAN = '\033[38;2;80;128;192m'
    FG4 = '\033[38;2;107;120;136m'
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
