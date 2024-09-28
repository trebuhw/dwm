#!/bin/bash

term="kitty -e"
edit="vim"

chosen=$(printf "nerdtree\nranger\nsway\nvim\n* ADD NEW APP" | rofi -dmenu -i -p " KEYBOARD SHORTCUTS ")

case "$chosen" in
	"nerdtree") $term $edit $HOME/Dokumenty/keyshortcuts/nerdtree.txt;;
	"ranger") $term $edit $HOME/Dokumenty/keyshortcuts/ranger.txt ;;
	"sway") $term $edit $HOME/Dokumenty/keyshortcuts/sway.txt ;;
	"vim") $term $edit $HOME/Dokumenty/keyshortcuts/vim.txt ;;
	"* ADD NEW APP") $term $edit $HOME/.config/scripts/rofi/keyshortcuts.sh ;;
   	*) exit 1 ;;
esac
