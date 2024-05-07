#!/bin/bash

# packer="sudo zypper -n install" # Wersja skrócona polecenia
packer="sudo zypper --non-interactive install --no-recommends"

$packer alacritty
$packer bash-completion
$packer bat
$packer brightnessctl
$packer btop
$packer cpuid
$packer cups
$packer curl
$packer dconf-editor
$packer duf
$packer dunst
$packer fastfetch
$packer feh
$packer file-roller
$packer firefox
$packer fish
$packer flameshot
$packer font-manager
$packer galculator
$packer gcc
$packer gcolor3
$packer gimp
$packer git
$packer gnome-disk-utility
$packer gparted
$packer gsettings-desktop-schemas
$packer gzip
$packer harfbuzz-devel
$packer htop
$packer i3lock
$packer kitty
$packer libreoffice
$packer libreoffice-l10n-pl
$packer libstdc++6-32bit 
$packer libX11-devel
$packer libXft-devel
$packer libXinerama-devel
$packer libxcb-res0
$packer lsd
$packer lxappearance
$packer mako
$packer meld
$packer mlocate
$packer neofetch
$packer neovim
$packer NetworkManager-applet
$packer ncurses-devel
$packer numlockx
$packer opi
$packer os-prober
$packer p7zip
$packer papirus-icon-theme
$packer parcellite
$packer pavucontrol
$packer pdfarranger
$packer picom
$packer polkit
$packer polkit-gnome
$packer ranger
$packer rclone
$packer rclone
$packer ripgrep
$packer rofi
$packer rsync
$packer scrot
$packer sensors
$packer starship
$packer sxhkd
$packer sxiv
$packer system-config-printer
$packer tealdeer
$packer tealdeer-fish-completion
$packer thunar
$packer thunar-volman
$packer time
$packer tlp
$packer tree
$packer ueberzugpp
$packer unrar
$packer unzip
$packer vim
$packer vlc
$packer wget
$packer xclip
$packer xdg-user-dirs
$packer xfce4-notifyd
$packer xinit
$packer xorg-x11-driver-video
$packer xorg-x11-essentials
$packer xorg-x11-fonts
$packer xorg-x11-fonts-converted
$packer xorg-x11-fonts-core
$packer xorg-x11-fonts-legacy
$packer xorg-x11-libX11-ccache
$packer xorg-x11-server
$packer xorg-x11-server-extra
$packer xorg-x11-server-Xvfb
$packer xorg-x11-Xvnc
$packer xorg-x11-Xvnc-module
$packer xorgproto-devel
$packer xwininfo
$packer yazi
$packer zathura
$packer zathura-plugin-pdf-poppler

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
packer openSUSE-repos-Tumbleweed-NVIDIA # Równoznaczne z powyższym
sudo zypper refresh
#sudo zypper search nvidia

# Install Drives
#$packer kernel-firmware-nvidia
#$packer libnvidia-egl-wayland1
#$$packer nvidia-compute-G06
#$packer nvidia-compute-G06-32bit
#$packer nvidia-driver-G06-kmp-default
#$packer nvidia-gl-G06
#$packer nvidia-gl-G06-32bit
#$packer nvidia-video-G06
#$packer nvidia-video-G06-32bit
#$packer openSUSE-repos-MicroOS-NVIDIA

# File Coopy
sudo cp /etc/tlp.conf /etc/tlp.conf.bak
sudo cp ~/dwm/files/etc/tlp.conf /etc
sudo cp -r ~/dwm/files/usr/share/rofi /usr/share
sudo cp -r ~/dwm/files/usr/share/xsessions/dwm.desktop /usr/share/xsessions
sudo cp -r ~/dwm/files/usr/share/fonts/* /usr/share/fonts
sudo cp -r ~/dwm/files/usr/share/icons/* /usr/share/icons
sudo cp -r ~/dwm/files/usr/share/themes/* /usr/share/themes
#sudo cp ~/dwm/files/etc/X11/xorg.conf.d/20-intel.conf /etc/X11/xorg.conf.d

# Coppy files
cp ~/dwm/files/home/* ~/
cp -r ~/dwm/files/.icons ~/
cp -r ~/dwm/files/.config/* ~/.config
sudo ln -s ~/.config/yazi/ /root/.config/
sudo ln -s ~/.config/ranger/ /root/.config/

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
gsettings set org.gnome.desktop.interface font-name 'MesloLGS Nerd Font 10'

sudo sed -i 's/Y2NCURSES_COLOR_THEME="[^"]*"/Y2NCURSES_COLOR_THEME="rxvt"/' /etc/sysconfig/yast2

systemctl reboot
