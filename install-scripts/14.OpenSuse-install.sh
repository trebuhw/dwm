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
$packer gzip
$packer harfbuzz-devel
$packer htop
$packer i3lock
$packer kitty
$packer libreoffice
$packer libreoffice-l10n-pl
$packer libX11-devel
$packer libXft-devel
$packer libXinerama-devel
$packer lsd
$packer lxappearance
$packer mako
$packer meld
$packer mlocate
$packer neofetch
$packer neovim
$packer NetworkManager-applet
$packer numlockx
$packer opi
$packer os-prober
$packer p7zip
$packer papirus-icon-theme
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
$packer sensors
$packer starship
$packer sxhkd
$packer sxiv
$packer system-config-printer
$packer thunar
$packer thunar-volman
$packer time
$packer tlp
$packer tree
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

# Install GitHub Desktop
sudo rpm --import https://rpm.packages.shiftkey.dev/gpg.key
sudo sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/zypp/repos.d/shiftkey-packages.repo'
sudo sh -c 'echo -e "[mwt-packages]\nname=GitHub Desktop\nbaseurl=https://mirror.mwt.me/shiftkey-desktop/rpm\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://mirror.mwt.me/shiftkey-desktop/gpgkey" > /etc/zypp/repos.d/mwt-packages.repo'
sudo zypper refresh && $packer github-desktop

# OPI APP
opi google-chrome
opi trash-cli
opi subl

# Instalować dopiero po dodaniu repo Nvidia
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
#$packer openSUSE-repos-Tumbleweed-NVIDIA

# File Coopy
sudo cp /etc/tlp.conf /etc/tlp.conf.bak
sudo cp ~/dwm-install/files/etc/tlp.conf /etc
sudo cp -r ~/dwm-install/files/usr/share/rofi /usr/share
sudo cp -r ~/dwm-install/files/usr/share/xsessions/dwm.desktop /usr/share/xsessions
sudo cp -r ~/dwm-install/files/usr/share/fonts/JetBrainsMono /usr/share/JetBrainsMono
sudo cp -r ~/dwm-install/files/usr/share/icons/Bibata-Modern-Ice /usr/share/icons
sudo cp -r ~/dwm-install/files/usr/share/themes/Catppuccin-Mocha-Standard-Blue-Dark /usr/share/themes
sudo cp ~/dwm-install/files/etc/X11/xorg.conf.d/20-intel.conf /etc/X11/xorg.conf.d

cp ~/dwm-install/files/.vimrc ~/
cp ~/dwm-install/files/.xinitrc ~/
cp ~/dwm-install/files/.Xresources ~/
cp ~/dwm-install/files/.background ~/
cp ~/dwm-install/files/.bash_history ~/
cp ~/dwm-install/files/.bashrc ~/

cp -r ~/dwm-install/files/.icons ~/
cp -r ~/dwm-install/files/.config/* ~/.config

sudo chsh $USER -s /usr/bin/fish

sudo fc-cache -fv

# Install May DWM
cd ~/.config/dwm && make && sudo make clean install && cd ~
cd ~/.config/dwm/dmenu && make && sudo make clean install && cd ~
cd ~/.config/dwm/slstatus && make && sudo make clean install && cd ~
cd ~/.config/dwm/st && make && sudo make clean install


# Theme set
gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Blue-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font 10'

plik_konfiguracyjny="/etc/sysconfig/yast2" zmienna_do_zamiany="Y2NCURSES_COLOR_THEME" nowa_wartosc="rxvt" && if grep -q "^$zmienna_do_zamiany" "$plik_konfiguracyjny"; then sed -i "s/^$zmienna_do_zamiany=.*/$zmienna_do_zamiany=\"$nowa_wartosc\"/" "$plik_konfiguracyjny" && echo "Zamieniono wartość $zmienna_do_zamiany na \"$nowa_wartosc\"."; else echo "$zmienna_do_zamiany nie zostało znalezione w pliku $plik_konfiguracyjny."; fi

systemctl reboot
