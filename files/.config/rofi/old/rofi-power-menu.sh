#!/usr/bin/env bash

#! /bin/sh

chosen=$(printf "  Power Off\n  Restart\n  Lock" | rofi -dmenu -i -p " POWER ")

case "$chosen" in
	"  Power Off") poweroff ;;
	"  Restart") reboot ;;
	"  Lock") $HOME/.config/swaylock/lock.sh ;;
	*) exit 1 ;;
esac
