#!/bin/bash

# --- Configuration Variables ---
BUILTIN_DISPLAY="eDP-1"
EXTERNAL_DISPLAY="HDMI-1"

# Define your distinct resolutions
BUILTIN_RES="1920x1080"
EXTERNAL_RES_2K="2560x1440"
EXTERNAL_RES_1080="1920x1080"

# --- Wallpaper Configuration ---
WP_BUILTIN="$HOME/Pictures/tower.jpg"
WP_EXTERNAL="$HOME/Pictures/minimal.jpg"

# --- Main Logic ---

# Get a list of currently connected displays
CONNECTED_DISPLAYS=$(xrandr --query | grep " connected" | awk '{print $1}')
NUM_CONNECTED=$(echo "$CONNECTED_DISPLAYS" | wc -l)

echo "Detected $NUM_CONNECTED connected display(s)."

if echo "$CONNECTED_DISPLAYS" | grep -q "$EXTERNAL_DISPLAY"; then
    # ==========================================
    # CASE 1: DUAL MONITOR (HDMI PLUGGED IN)
    # ==========================================
    echo "External monitor detected. Checking resolution capabilities..."

    # Check if the connected external monitor supports 2K resolution
    if xrandr --query | awk "/^$EXTERNAL_DISPLAY connected/,/^[^ ]/" | grep -q "$EXTERNAL_RES_2K"; then
        # CASE 1A: 2K Monitor Detected
        echo "2K monitor supported. Forcing 2K layout at 120Hz..."
        xrandr --output "$EXTERNAL_DISPLAY" --primary --mode "$EXTERNAL_RES_2K" --rate 120.00 --scale 1x1 \
               --output "$BUILTIN_DISPLAY" --mode "$BUILTIN_RES" --scale 1x1 --left-of "$EXTERNAL_DISPLAY"
    else
        # CASE 1B: 1080p Monitor Detected
        echo "2K not supported. Adapting to 1080p layout..."
        xrandr --output "$EXTERNAL_DISPLAY" --primary --mode "$EXTERNAL_RES_1080" --scale 1x1 \
               --output "$BUILTIN_DISPLAY" --mode "$BUILTIN_RES" --scale 1x1 --left-of "$EXTERNAL_DISPLAY"
    fi

    # Turn off any ghost/disconnected display ports
    for display in $(xrandr | grep " disconnected" | awk '{print $1}'); do
        xrandr --output "$display" --off
    done

    # Wait for X11 to apply the new screen boundaries
    sleep 3 

    # Apply wallpapers (Order mapped for your specific setup)
    feh --bg-fill "$WP_EXTERNAL" --bg-fill "$WP_BUILTIN" 

    echo "Dual monitor layout complete."

elif echo "$CONNECTED_DISPLAYS" | grep -q "$BUILTIN_DISPLAY"; then
    # ==========================================
    # CASE 2: SINGLE MONITOR (LAPTOP ONLY)
    # ==========================================
    echo "Only built-in display detected. Setting single layout."

    # Set Layout (Laptop Primary, HDMI off)
    xrandr --output "$BUILTIN_DISPLAY" --primary --mode "$BUILTIN_RES" --scale 1x1 --pos 0x0 \
           --output "$EXTERNAL_DISPLAY" --off

    # Wait just a moment for safety
    sleep 1

    # Apply single wallpaper
    feh --bg-fill "$WP_BUILTIN"

    echo "Single monitor layout complete."

else
    # ==========================================
    # CASE 3: FALLBACK (SOMETHING WENT WRONG)
    # ==========================================
    echo "Warning: Could not find expected displays. Falling back to auto."
    xrandr --auto
    sleep 1
    feh --bg-fill "$WP_BUILTIN"
fi
