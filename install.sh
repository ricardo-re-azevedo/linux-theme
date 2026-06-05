#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clean up old install
rm -rf $HOME/.local/share/theme
rm -f $HOME/.local/bin/theme

# Install
mkdir -p $HOME/.local/share/theme
cp -r $SCRIPT_DIR/. $HOME/.local/share/theme/

mkdir -p $HOME/.local/bin
ln -s $HOME/.local/share/theme/theme.sh $HOME/.local/bin/theme
ln -s $HOME/.local/share/theme/set-wallpaper.sh $HOME/.local/bin/set-wallpaper

# run theming
$HOME/.local/share/theme/theme.sh "mono"
