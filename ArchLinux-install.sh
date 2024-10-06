#!/bin/bash

packer="sudo pacman -S --noconfirm --needed"

cd ~/ && git clone https://aur.archlinux.org/yay.git
cd ~/yay && makepkg -si && cd ..

sudo pacman -Syyu

$packer adobe-source-sans-fonts
$packer aic94xx-firmware
$packer alacritty
$packer arandr
$packer arc-gtk-theme
$packer archiso
$packer avahi
$packer awesome-terminal-fonts
$packer bash-completion
$packer bat
$packer brightnessctl
$packer btop
$packer cpuid
$packer cups
$packer curl
$packer dconf-editor
$packer downgrade
$packer duf
$packer dunst
$packer fastfetch
$packer feh
$packer file-roller
$packer firefox
$packer fish
$packer flameshot
$packer font-manager
$packer fzf
$packer galculator
$packer gcolor3
$packer geany
$packer gimp
$packer git
$packer gnome-disk-utility
$packer gparted
$packer grub-customizer
$packer gtop
$packer gvfs-smb
$packer gzip
$packer hardcode-fixer-git
$packer hardinfo-gtk3
$packer hddtemp
$packer htop
$packer hw-probe
$packer i3lock
$packer kitty
$packer libreoffice-fresh
$packer libreoffice-fresh-pl
$packer linux-firmware-qlogic
$packer lm_sensors
$packer logrotate
$packer lolcat
$packer lsd
$packer lshw
$packer man-db
$packer man-pages
$packer meld
$packer mintstick-git
$packer mkinitcpio-firmware
$packer mlocate
$packer most
$packer neovim
$packer network-manager-applet
$packer networkmanager-openvpn
$packer noto-fonts
$packer nss-mdns
$packer ntp
$packer numlockx
$packer nwg-look
$packer openresolv
$packer os-prober
$packer p7zip
$packer papirus-icon-theme
$packer parcellite
$packer pavucontrol
$packer pdfarranger
$packer picom
$packer playerctl
$packer polkit
$packer polkit-gnome
$packer ranger
$packer rclone
$packer ripgrep
$packer rofi
$packer rsync
$packer scrot
$packer sparklines-git
$packer speedtest-cli-git
$packer spotify
$packer squashfs-tools
$packer scrot
$packer starship
$packer sxhkd
$packer sxiv
$packer system-config-printer
$packer thunar
$packer thunar-volman
$packer thunderbird
$packer time
$packer tldr
$packer tlp
$packer trash-cli
$packer tree
$packer ttf-jetbrains-mono-nerd
$packer ueberzug
$packer unrar
$packer unzip
$packer upd72020x-fw
$packer vim
$packer vlc
$packer wd719x-firmware
$packer wget
$packer wttr
$packer xclip
$packer xcolor
$packer xdg-user-dirs
$packer xfce4-notifyd
$packer xorg-server
$packer xorg-xinit
$packer xorg-xkill
$packer xorg-xrandr
$packer xorg-xsetroot
$packer zathura
$packer zoxide

yay archlinux-tweak-tool-git
yay bibata-cursor-theme
yay update-grub
yay xwininfo
yay google-chrome

sudo systemctl enable avahi-daemon.service
sudo systemctl enable ntpd.service

# File Coopy
#sudo cp /etc/tlp.conf /etc/tlp.conf.bak
#sudo cp ~/dwm/files/etc/tlp.conf /etc
sudo cp -r ~/dwm/files/usr/share/rofi /usr/share
sudo cp -r ~/dwm/files/usr/share/xsessions/dwm.desktop /usr/share/xsessions
sudo cp -r ~/dwm/files/usr/share/fonts/* /usr/share/fonts
sudo cp -r ~/dwm/files/usr/share/icons/* /usr/share/icons
sudo cp -r ~/dwm/files/usr/share/themes/* /usr/share/themes
cp -r ~/dwm/files/.local/share/* ~/.local/share
#sudo cp ~/dwm/files/etc/X11/xorg.conf.d/20-intel.conf /etc/X11/xorg.conf.d

# Coppy files
cp -r ~/dwm/files/home/* ~/
cp -r ~/dwm/files/.icons ~/
cp -r ~/dwm/files/.config/* ~/.config
sudo ln -s ~/.config/yazi/ /root/.config
sudo ln -s ~/.config/ranger/ /root/.config
sudo ln -s ~/.config/gtk-2.0/ /root/.config
sudo ln -s ~/.config/gtk-3.0/ /root/.config
sudo ln -s ~/.config/gtk-4.0/ /root/.config


# Make the file executable
cd /usr/share/xsessions
sudo chmod +x dwm.desktop

# Change shell to fish
#sudo chsh $USER -s /usr/bin/fish

sudo fc-cache -fv

# Install May DWM
cd ~/.config/suckless/dwm && make && sudo make clean install && cd ~
cd ~/.config/suckless/dmenu && make && sudo make clean install && cd ~
cd ~/.config/suckless/slstatus && make && sudo make clean install && cd ~
cd ~/.config/suckless/st && make && sudo make clean install

# Theme set
gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Blue-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Qogir-white-cursors'
gsettings set org.gnome.desktop.interface font-name 'Fira Code 10'

#sudo sed -i 's/Y2NCURSES_COLOR_THEME="[^"]*"/Y2NCURSES_COLOR_THEME="rxvt"/' /etc/sysconfig/yast2

systemctl reboot
