#!/bin/bash

sudo cp /etc/tlp.conf /etc/tlp.conf.bak
sudo cp ~/dwm-install/files/etc/tlp.conf /etc
sudo cp -r ~/dwm-install/files/usr/share/* /usr/share
sudo mv /etc/pacman.conf /etc/pacman.conf.bak
sudo cp ~/dwm-install/files/etc/pacman.conf /etc/
sudo cp ~/dwm-install/files/etc/pacman.d/* /etc/pacman.d/
sudo cp -r /etc/pacman.d /etc/pacman.d.bak

cp ~/dwm-install/files/.vimrc ~/
cp ~/dwm-install/files/.xinitrc ~/
cp ~/dwm-install/files/.Xresources ~/
cp ~/dwm-install/files/.background ~/
cp ~/dwm-install/files/.bash_history ~/
cp ~/dwm-install/files/.bashrc ~/

cp -r ~/dwm-install/files/.icons ~/
cp -r ~/dwm-install/files/.config/* ~/.config

sudo chsh $USER -s /bin/fish

exit 0
