#!/usr/bin/bash

path=$1

hyprctl hyprpaper unload all
hyprctl hyprpaper preload $path
hyprctl hyprpaper wallpaper ", $path"

# Rebuild hyprpaper.conf
OUTPUT_FILE="$HOME/.config/hypr/hyprpaper.conf"

# Clear the output file
> "$OUTPUT_FILE"

echo "splash = false

preload = $path

wallpaper {
    monitor =
    path = $path
}
" >> "$OUTPUT_FILE"

# Update hyprlock wallpaper
sed -i "s|.*path.*|    path = ${path}|" "$HOME/.config/hypr/hyprlock.conf"
