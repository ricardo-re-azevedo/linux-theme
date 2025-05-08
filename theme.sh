#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No theme name provided"
    echo "Usage: $0 <${valid_args[*]}>"
    exit 1
fi

read_theme() {
  THEME_FILE="$THEMES_DIR/$1"

  if [ ! -f "${THEME_FILE}" ]; then
    echo "Theme file does not exist: ${THEME_FILE}"
    exit 1
  fi
  # export all vars from config file
  # remove comments and whitespace
  sed -e '/^#/d' "${THEME_FILE}" | sed -r 's/ *=[ ]*/=/g' > "tmp.theme"
  set -a
  . "tmp.theme"
  THEME_VAR_NAMES=$(grep -E '[a-zA-Z0-9"'\''\[\]]*=' "tmp.theme" |grep -E -v '^#' |cut -d'=' -f1 |awk '{print "$" $1}')
  rm "tmp.theme"
  set +a
}

hypr() {
  # Hyprland theme
  mkdir -p "$HOME/.config/hypr"
  envsubst "${THEME_VAR_NAMES}" < "./templates/hypr/hyprland.conf" > "$HOME/.config/hypr/hyprland.conf"
  envsubst "${THEME_VAR_NAMES}" < "./templates/hypr/hyprlock.conf" > "$HOME/.config/hypr/hyprlock.conf"
  envsubst "${THEME_VAR_NAMES}" < "./templates/hypr/keybindings.conf" > "$HOME/.config/hypr/keybindings.conf"

  # col.active_border must be in format rgba(ffffff) without a #
  sed -i -e 's/col.active_border = rgba(#/col.active_border = rgba(/g' "$HOME/.config/hypr/hyprland.conf"
}

tofi() {
  # Hyprland theme
  THEME_TEMPLATE="./templates/tofi/config"
  mkdir -p "$HOME/.config/tofi"
  envsubst "${THEME_VAR_NAMES}" < "${THEME_TEMPLATE}" > "$HOME/.config/tofi/config"
}

okpanel() {
  export theme_list=""
  for fp in "themes"/*; do
      # get theme filenames
      fn=$(basename "$fp")
      read_theme $fn
      theme_list+=$(envsubst < "./templates/okpanel/_theme")
  done
  envsubst < "./templates/okpanel/okpanel.conf" > "$HOME/.config/OkPanel/okpanel.conf"
}

read_theme $1
# Immediately visible first
hypr

# Then the rest
tofi
okpanel # update theme file but okpanel with update the theme itself. Needs to be done last