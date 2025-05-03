#!/usr/bin/bash

path=$1

hyprctl hyprpaper unload all
hyprctl hyprpaper preload $path
hyprctl hyprpaper wallpaper ", $path"

# Rebuild hyprpaper.conf
OUTPUT_FILE="$HOME/.config/hypr/hyprpaper.conf"

# Clear the output file
> "$OUTPUT_FILE"

echo "splash = false" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "preload = $path" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "wallpaper = , $path" >> "$OUTPUT_FILE"

# Update hyprlock wallpaper
sed -i "s|.*path.*|    path = ${path}|" "$HOME/.config/hypr/hyprlock.conf"
