#!/bin/sh

# horizon Theme - Toggle Music
# Reads music path from showcase.conf

CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/colorschemes/horizon"
CONF_FILE="$CONF_DIR/showcase.conf"

# Source config if exists
if [ -f "$CONF_FILE" ]; then
    . "$CONF_FILE"
fi

# Exit silently if no music configured
if [ -z "$MUSIC_PATH" ] || [ ! -f "$MUSIC_PATH" ]; then
    exit 0
fi

# Toggle playback
if pgrep -f "mpv.*horizon-showcase"; then
    pkill -f "mpv.*horizon-showcase"
else
    mpv --no-video --title="horizon-showcase" "$MUSIC_PATH" &
fi
