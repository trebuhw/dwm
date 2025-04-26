#!/bin/bash

set -e

log() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

check_success() {
    if [ $? -ne 0 ]; then
        error "$1"
        exit 1
    fi
}

# Wykrywanie dystrybucji
if [ -f /etc/arch-release ]; then
    DISTRO="arch"
    log "Wykryto dystrybucję: Arch Linux"
elif [ -f /etc/lsb-release ] && grep -qi "ubuntu" /etc/lsb-release; then
    DISTRO="ubuntu"
    log "Wykryto dystrybucję: Ubuntu"
elif [ -f /etc/debian_version ]; then
    DISTRO="debian"
    log "Wykryto dystrybucję: Debian"
elif grep -qi "opensuse" /etc/os-release; then
    DISTRO="opensuse"
    log "Wykryto dystrybucję: openSUSE"
elif grep -qi "fedora" /etc/os-release; then
    DISTRO="fedora"
    log "Wykryto dystrybucję: Fedora"
else
    error "Nieobsługiwana dystrybucja. Skrypt obsługuje: Arch, Ubuntu, Debian, Fedora, openSUSE."
    exit 1
fi

# Instalacja yay dla Arch Linux
install_yay() {
    if ! command -v yay &> /dev/null; then
        log "Instalacja yay z AUR..."
        tempdir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$tempdir/yay"
        (
            cd "$tempdir/yay" || exit 1
            makepkg -si --noconfirm
        )
        rm -rf "$tempdir"
        check_success "Nie udało się zainstalować yay"
    else
        log "yay jest już zainstalowany"
    fi
}

# Zależności DWM
install_dwm_deps() {
    case "$DISTRO" in
        arch)
            log "Instalacja zależności DWM dla Arch Linux..."
            sudo pacman -S --needed --noconfirm base-devel libx11 libxinerama libxft xorg xorg-server xorg-xinit
            ;;
        ubuntu|debian)
            log "Instalacja zależności DWM dla $DISTRO..."
            sudo apt update
            sudo apt install -y libharfbuzz-dev libxft-dev libpango1.0-dev build-essential \
                libx11-dev libxinerama-dev libxcb1-dev libxcb-keysyms1-dev libxcb-icccm4-dev \
                libx11-xcb-dev libxcb-util0-dev libxcb-randr0-dev suckless-tools libfreetype6-dev
            ;;
        fedora)
            log "Instalacja zależności DWM dla Fedora..."
            sudo dnf install -y @development-tools libX11-devel libXinerama-devel libXft-devel \
                xorg-x11-server-Xorg xorg-x11-xinit
            ;;
        opensuse)
            log "Instalacja zależności DWM dla openSUSE..."
            sudo zypper install -y gcc harfbuzz-devel  patterns-devel-base-devel_basis libX11-devel libXinerama-devel libXft-devel make \
                xorg-x11-server xinit
            ;;
    esac
    check_success "Nie udało się zainstalować zależności DWM"
}

# Pakiety wspólne (repozytoria oficjalne)
COMMON_PACKAGES=(
    bash-completion bat blueman brightnessctl btop cups curl dunst feh file-roller firefox fish fzf galculator gcc gcolor3 gnome-disk-utility gparted gsettings-desktop-schemas gzip htop i3lock kitty mako meld neovim numlockx p7zip parcellite pavucontrol pdfarranger picom rclone ripgrep rofi rsync scrot stow sxhkd thunar thunar-archive-plugin thunar-volman time trash-cli tree tumbler unrar unzip vim vlc wget xclip xdg-user-dirs xfce4-notifyd zathura zoxide
)

# Odpowiedniki i pakiety dodatkowe
case "$DISTRO" in
    arch)
        PACMAN_PACKAGES=("${COMMON_PACKAGES[@]}" alacritty code eza fastfetch font-manager libreoffice-fresh libreoffice-fresh-pl polkit-gnome network-manager-applet nsxiv mlocate os-prober starship xf86-input-synaptics xf86-video-intel wezterm yazi)
        YAY_PACKAGES=(google-chrome lm_sensors nwg-look ueberzug)
        ;;
    ubuntu)
        PACMAN_PACKAGES=("${COMMON_PACKAGES[@]}" alacritty eza fastfetch font-manager nwg-look policykit-1-gnome network-manager-gnome mlocate starship sxiv xserver-xorg-input-synaptics xserver-xorg-video-intel wezterm yazi)
        ;;
    debian)
        PACMAN_PACKAGES=("${COMMON_PACKAGES[@]}" alacritty font-manager neofetch lxappearance policykit-1-gnome network-manager-gnome mlocate xserver-xorg-input-synaptics xserver-xorg-video-intel)
        ;;
    fedora)
        PACMAN_PACKAGES=("${COMMON_PACKAGES[@]}" alacritty fastfetch lxappearance polkit network-manager-applet sxiv xorg-x11-drv-synaptics xorg-x11-drv-intel )
        ;;
    opensuse)
        PACMAN_PACKAGES=("${COMMON_PACKAGES[@]}" alacritty eza fastfetch font-manager lxappearance opi polkit-gnome NetworkManager-applet mlocate starship sxiv sensors ueberzugpp wezterm yazi zathura-plugin-pdf-mupdf)
        ;;
esac

# Instalacja pakietów z repozytoriów
install_repo_packages() {
    local pkgs=("$@")
    case "$DISTRO" in
        arch)
            sudo pacman -S --needed --noconfirm "${pkgs[@]}"
            ;;
        ubuntu|debian)
            sudo apt install -y "${pkgs[@]}"
            ;;
        fedora)
            sudo dnf install -y "${pkgs[@]}"
            ;;
        opensuse)
            sudo sudo zypper --non-interactive install --no-recommends "${pkgs[@]}"
            ;;
    esac
}

# Instalacja zależności
install_dwm_deps

# Instalacja yay + pacman packages
if [ "$DISTRO" = "arch" ]; then
    install_yay
    log "Instalacja pakietów z repozytoriów (pacman)..."
    install_repo_packages "${PACMAN_PACKAGES[@]}"
    check_success "Nie udało się zainstalować pakietów z pacman"

    log "Instalacja pakietów z AUR (yay)..."
    yay -S --needed --noconfirm "${YAY_PACKAGES[@]}"
    check_success "Nie udało się zainstalować pakietów AUR"
else
    log "Instalacja pakietów..."
    install_repo_packages "${PACMAN_PACKAGES[@]}"
    check_success "Nie udało się zainstalować pakietów"
fi

log "Instalacja zakończona pomyślnie!"

# Klonowanie repozytorium
log "Klonowanie repozytorium dotfiles..."
if [ -d ~/.dotfiles ]; then
    read -p "Katalog ~/.dotfiles już istnieje. Czy chcesz go nadpisać? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf ~/.dotfiles
    else
        error "Anulowano. Katalog ~/.dotfiles już istnieje."
        exit 1
    fi
fi

git clone --depth 1 https://github.com/trebuhw/.dotfiles ~/.dotfiles
check_success "Nie udało się sklonować repozytorium"

# Tworzenie kopii zapasowych
log "Tworzenie kopii zapasowych plików konfiguracyjnych..."
[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
[ -f ~/.bash_logout ] && mv ~/.bash_logout ~/.bash_logout.bak
[ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.bash_profile.bak
[ -f ~/.gtkrc-2.0 ] && mv ~/.gtkrc-2.0 ~/.gtkrc-2.0.bak
[ -d ~/.config/gtk-2.0 ] && mv ~/.config/gtk-2.0 ~/gtk-2.0.bak
[ -d ~/.config/gtk-3.0 ] && mv ~/.config/gtk-3.0 ~/gtk-3.0.bak
[ -d ~/.config/gtk-4.0 ] && mv ~/.config/gtk-4.0 ~/gtk-4.0.bak

# Stow
log "Tworzenie symlinków za pomocą stow..."
cd ~/.dotfiles || { error "Nie można przejść do katalogu ~/.dotfiles"; exit 1; }
stow Xresources/ alacritty/ background/ bash/ btop/ dunst/ fish/ fonts/ gtk-2.0/ gtk-3.0/ gtk-4.0/ gtkrc-2.0/ icons/ kitty/ mc/ nvim/ ranger/ rofi/ suckless/ nsxiv/ parcellite/ themes/ sxiv/ vim/ xinitrc/ xprofile/ yazi/ wezterm/ zathura/
check_success "Błąd podczas wykonywania stow"

# Kompilacja i instalacja DWM
log "Kompilacja i instalacja DWM..."
cd ~/.config/suckless/dwm || { error "Nie można przejść do katalogu DWM"; exit 1; }
[ -f config.h ] && rm config.h
sudo make && sudo make clean install && rm -f config.h
check_success "Błąd podczas kompilacji DWM"

# Kompilacja i instalacja DMENU
log "Kompilacja i instalacja DMENU..."
cd ~/.config/suckless/dmenu || { error "Nie można przejść do katalogu DMENU"; exit 1; }
[ -f config.h ] && rm config.h
sudo make && sudo make clean install && rm -f config.h
check_success "Błąd podczas kompilacji DMENU"

# Kompilacja i instalacja slstatus
log "Kompilacja i instalacja slstatus..."
cd ~/.config/suckless/slstatus || { error "Nie można przejść do katalogu slstatus"; exit 1; }
[ -f config.h ] && rm config.h
sudo make && sudo make clean install && rm -f config.h
check_success "Błąd podczas kompilacji slstatus"

# Kompilacja i instalacja st
log "Kompilacja i instalacja st (terminal)..."
cd ~/.config/suckless/st || { error "Nie można przejść do katalogu st"; exit 1; }
sudo make && sudo make clean install
check_success "Błąd podczas kompilacji st"

# Instalacja pliku .desktop
log "Kopiowanie pliku .desktop..."
[ -d /usr/share/xsessions ] || sudo mkdir -p /usr/share/xsessions
sudo cp ~/.config/suckless/usr/share/xsessions/dwm.desktop /usr/share/xsessions/
check_success "Nie udało się skopiować pliku .desktop"

log "Instalacja zakończona pomyślnie!"
log "Aby uruchomić DWM, wyloguj się i wybierz sesję DWM z menedżera logowania."

# Dodanie czcionek
sudo fc-cache -fv

# Ustawienie theme gtk
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
gsettings set org.gnome.desktop.interface cursor-size 20 
gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "Catppuccin-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Tela-circle-dracula-dark"
gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font 10'
ln -sf ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini

# Ustawienie konfiguracji programów root

sudo mkdir -p /root/.config/
sudo ln -sf ~/dotfiles/gtkrc-2.0/.gtkrc-2.0 /root/.gtkrc-2.0
sudo ln -sf ~/dotfiles/vim/.vimrc /root/.vimrc
sudo ln -sf ~/dotfiles/vim/.viminfo /root/.viminfo
sudo ln -sf ~/dotfiles/nvim/.config/nvim /root/.config/nvim
sudo ln -sf ~/dotfiles/mc/.config/mc /root/.config/mc
sudo ln -sf ~/dotfiles/gtk-4.0/.config/gtk-4.0 /root/.config/gtk-4.0
sudo ln -sf ~/dotfiles/gtk-3.0/.config/gtk-3.0 /root/.config/gtk-3.0
sudo ln -sf ~/dotfiles/gtk-2.0/.config/gtk-2.0 /root/.config/gtk-2.0
sudo ln -sf ~/dotfiles/ranger/.config/ranger /root/.config/ranger

# Zmiana powłoki shell
sudo chsh $USER -s /bin/fish && echo 'Now log out.'

# Pytanie o reboot
read -p "Czy chcesz teraz zrestartować system? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "Restartuję system..."
    sudo systemctl reboot
fi

exit 0
