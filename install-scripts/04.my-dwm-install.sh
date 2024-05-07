#!/bin/bash

cd ~/.config/dwm && make && sudo make clean install && cd ~
cd ~/.config/dwm/dmenu && make && sudo make clean install && cd ~
cd ~/.config/dwm/slstatus && make && sudo make clean install && cd ~
cd ~/.config/dwm/st && make && sudo make clean install

exit 0
