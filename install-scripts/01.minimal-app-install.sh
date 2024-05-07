#!/bin/bash

packer="sudo pacman -S --noconfirm --needed"

cd ~/ && git clone https://aur.archlinux.org/yay.git
cd ~/yay && makepkg -si && cd ..

sudo pacman -Syyu

## Xorg & DWM

### Programs

$packer alacritty
$packer arc-gtk-theme
$packer bat
$packer bash-completion
$packer brightnessctl
$packer btop
$packer cups
$packer fastfetch
$packer feh
$packer file-roller
$packer firefox
$packer fish
$packer flameshot
$packer gcolor3
$packer git
$packer gzip
$packer i3lock
$packer kitty
$packer lm_sensors
$packer lsd
$packer lxappearance
$packer neofetch
$packer neovim
$packer network-manager-applet
$packer numlockx
$packer os-prober
$packer p7zip
$packer papirus-icon-theme
$packer picom
$packer polkit
$packer polkit-gnome
$packer ranger
$packer rclone
$packer rofi
$packer rsync
$packer starship
$packer sxhkd
$packer sxiv
$packer thunar
$packer thunar-volman
$packer tldr
$packer tlp
$packer trash-cli
$packer ttf-jetbrains-mono-nerd
$packer unrar
$packer unzip
$packer vim
$packer xclip
$packer xdg-user-dirs
$packer xfce4-notifyd
$packer xorg-server
$packer xorg-xinit
$packer xorg-xrandr
$packer xorg-xsetroot
$packer yazi
$packer zathura
yay archlinux-tweak-tool-git
yay bibata-cursor-theme

exit 0




