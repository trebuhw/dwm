#!/bin/bash

term="kitty -e"
edit="vim"

c1="bash"
c2="dunst"
c3="fish"
c4="kitty"
c5="ranger"
c6="sway"
c7="vim"
c8="waybar"

chosen=$(printf "$c1\n$c2\n$c3\n$c4\n$c5\n$c6\n$c7\n$c8\n* ADD NEW CONFIG FILE" | rofi -dmenu -i -p " CONFIG EDIT ")

case "$chosen" in
	"$c1") $term $edit $HOME/.bashrc ;;
	"$c2") $term $edit $HOME/.config/dunst/dunstrc ;;
	"$c3") $term $edit $HOME/.config/fish/config.fish ;;
	"$c4") $term $edit $HOME/.config/kitty/kitty.conf ;;
	"$c5") $term $edit $HOME/.config/ranger/rc.conf ;;
	"$c6") $term $edit $HOME/.config/sway/config ;;
	"$c7") $term $edit $HOME/.vimrc ;;
	"$c8") $term $edit $HOME/.config/waybar/style.css ;;
	"* ADD NEW CONFIG FILE") $term $edit $HOME/.config/scripts/rofi/config_edit.sh ;;
   	*) exit 1 ;;
esac
