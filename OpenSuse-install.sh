#!/bin/bash

# packer="sudo zypper -n install" # Wersja skrócona polecenia
packer="sudo zypper --non-interactive install --no-recommends"

$packer alacritty bash-completion bat brightnessctl btop cpuid cups curl dconf-editor duf dunst fastfetch feh file-roller firefox fish flameshot font-manager galculator gcc gcolor3 gimp git gnome-disk-utility gparted gsettings-desktop-schemas gzip harfbuzz-devel htop i3lock kitty libreoffice libreoffice-l10n-pl libstdc++6-32bit  libX11-devel libXft-devel libXinerama-devel libxcb-res0 lsd lxappearance mako meld mlocate neofetch neovim NetworkManager-applet ncurses-devel numlockx opi os-prober p7zip papirus-icon-theme parcellite pavucontrol pdfarranger picom polkit polkit-gnome ranger rclone ripgrep rofi rsync scrot sensors starship sxhkd sxiv system-config-printer tealdeer tealdeer-fish-completion thunar thunar-volman time tlp tree ueberzugpp unrar unzip vim vlc wget xclip xdg-user-dirs xfce4-notifyd xinit xorg-x11-driver-video xorg-x11-essentials xorg-x11-fonts xorg-x11-fonts-converted xorg-x11-fonts-core xorg-x11-fonts-legacy xorg-x11-libX11-ccache xorg-x11-server xorg-x11-server-extra xorg-x11-server-Xvfb xorg-x11-Xvnc xorg-x11-Xvnc-module xorgproto-devel xwininfo yazi zathura zathura-plugin-pdf-poppler zoxide  
# Install GitHub Desktop
sudo rpm --import https://rpm.packages.shiftkey.dev/gpg.key
sudo sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/zypp/repos.d/shiftkey-packages.repo'
# sudo sh -c 'echo -e "[mwt-packages]\nname=GitHub Desktop\nbaseurl=https://mirror.mwt.me/shiftkey-desktop/rpm\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://mirror.mwt.me/shiftkey-desktop/gpgkey" > /etc/zypp/repos.d/mwt-packages.repo'
sudo zypper refresh && $packer github-desktop 
# OPI APP
opi google-chrome
opi trash-cli
opi sublime

# Nvidia add repository
#zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
#packer openSUSE-repos-Tumbleweed-NVIDIA # Równoznaczne z powyższym
#sudo zypper refresh
#sudo zypper search nvidia

# Install Drives
# $packer kernel-firmware-nvidia libnvidia-egl-wayland1 nvidia-compute-G06 nvidia-compute-G06-32bit nvidia-driver-G06-kmp-default nvidia-gl-G06 nvidia-gl-G06-32bit nvidia-video-G06 nvidia-video-G06-32bit openSUSE-repos-MicroOS-NVIDIA 
# File Coopy
sudo cp /etc/tlp.conf /etc/tlp.conf.bak
sudo cp ~/dwm/files/etc/tlp.conf /etc
sudo cp -r ~/dwm/files/usr/share/rofi /usr/share
sudo cp -r ~/dwm/files/usr/share/xsessions/dwm.desktop /usr/share/xsessions
sudo cp -r ~/dwm/files/usr/share/fonts/* /usr/share/fonts
sudo cp -r ~/dwm/files/usr/share/icons/* /usr/share/icons
sudo cp -r ~/dwm/files/usr/share/themes/* /usr/share/themes
sudo cp -r ~/dwm/files/.local/share/* ~/.local/share
#sudo cp ~/dwm/files/etc/X11/xorg.conf.d/20-intel.conf /etc/X11/xorg.conf.d

# Coppy files
cp ~/dwm/files/home/* ~/
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
sudo chsh $USER -s /usr/bin/fish

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
gsettings set org.gnome.desktop.interface font-name 'MesloLGL Nerd Font 10'

sudo sed -i 's/Y2NCURSES_COLOR_THEME="[^"]*"/Y2NCURSES_COLOR_THEME="rxvt"/' /etc/sysconfig/yast2

systemctl reboot