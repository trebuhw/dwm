#!/usr/bin/env bash

term="kitty -e"
edit="nvim"

cd $HOME/.config/scripts/rofi/symboliclink/;
chosen=$( ls | awk '{print $1}' | rofi -dmenu -p "SYMLINKS");
file=$chosen;

# Exit if none chosen.
[ -z "$chosen" ] && exit

$term $edit $chosen | notify-send "$chosen / open and edit to vim"; 

