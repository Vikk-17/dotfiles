#!/bin/bash

# --- Configuration Variables ---
BUILTIN_DISPLAY="eDP-1"
EXTERNAL_DISPLAY="HDMI-1"
TARGET_RESOLUTION="1920x1080"
SCALE_FACTOR="1x1"

# --- Wallpaper Configuration ---
# Define which image belongs to which screen
# Based on your config, you had two images. Adjust paths if needed.
WP_BUILTIN="$HOME/Pictures/background.jpg"
WP_EXTERNAL="$HOME/Pictures/background2.jpg"

# --- Main Logic ---

# Get a list of currently connected displays
CONNECTED_DISPLAYS=$(xrandr --query | grep " connected" | awk '{print $1}')
NUM_CONNECTED=$(echo "$CONNECTED_DISPLAYS" | wc -l)

echo "Detected $NUM_CONNECTED connected display(s)."

# # Ensure all screens are reset to handle hotplugging cleanly
# xrandr --auto

if echo "$CONNECTED_DISPLAYS" | grep -q "$EXTERNAL_DISPLAY"; then
    # Case 1: Dual Monitor (External + Built-in)
    echo "External monitor detected. Setting dual layout."

    # 1. Set Layout (External Primary, Built-in Secondary on Right)
    xrandr --output "$EXTERNAL_DISPLAY" --primary --mode "$TARGET_RESOLUTION" --scale "$SCALE_FACTOR" --pos 0x0 \
           --output "$BUILTIN_DISPLAY" --mode "$TARGET_RESOLUTION" --scale "$SCALE_FACTOR" --right-of "$EXTERNAL_DISPLAY"

    # 2. Sync Wallpaper (Order: Primary First, Secondary Second)
    # Since HDMI is at 0x0, it is usually treated as the first screen by feh
    sleep 1 # Short pause to ensure X11 registers the new layout
    feh --bg-fill "$WP_EXTERNAL" --bg-fill "$WP_BUILTIN"

elif echo "$CONNECTED_DISPLAYS" | grep -q "$BUILTIN_DISPLAY"; then
    # Case 2: Single Monitor (Built-in only)
    echo "Only built-in display detected. Setting single layout."

    # 1. Set Layout
    xrandr --output "$BUILTIN_DISPLAY" --primary --mode "$TARGET_RESOLUTION" --scale "$SCALE_FACTOR" --pos 0x0 \
           --output "$EXTERNAL_DISPLAY" --off

    # 2. Sync Wallpaper
    feh --bg-fill "$WP_BUILTIN"

else
    # Case 3: Fallback
    echo "Warning: Could not find expected displays. Falling back to auto."
    xrandr --auto
    # Fallback wallpaper
    feh --bg-fill "$WP_BUILTIN"
fi

echo "Screen layout and wallpaper configuration complete."
