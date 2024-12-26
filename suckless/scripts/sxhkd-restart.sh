#!/bin/bash

sxhkd -c ~/.config/suckless/sxhkd/sxhkdrc &

notify-send "sxhkd restarted"

exit 0
