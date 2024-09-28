#!/bin/bash

sxhkd -c ~/.config/dwm/sxhkd/sxhkdrc &

notify-send "sxhkd restarted"

exit 0
