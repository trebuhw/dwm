#!/bin/bash
# Skrypt instalacji DWM z https://github.com/trebuhw/.dotfiles

# Funkcja do wyświetlania komunikatów
log() {
    echo "$(tput setaf 2)[$(date +%T)]$(tput sgr0) $1"
}

# Funkcja do wyświetlania błędów
error() {
    echo "$(tput setaf 1)[ERROR]$(tput sgr0) $1"
}

# Funkcja sprawdzająca czy ostatnia komenda zakończyła się sukcesem
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
elif [ -f /etc/lsb-release ] && grep -q "Ubuntu" /etc/lsb-release; then
    DISTRO="ubuntu"
    log "Wykryto dystrybucję: Ubuntu"
else
    error "Nieobsługiwana dystrybucja. Skrypt obsługuje tylko Arch Linux i Ubuntu."
    exit 1
fi

# Instalacja zależności w zależności od dystrybucji
if [ "$DISTRO" = "arch" ]; then
    log "Instalacja zależności DWM dla Arch Linux..."
    sudo pacman -S --needed --noconfirm base-devel libx11 libxinerama libxft xorg-server xorg-xinit
    check_success "Nie udało się zainstalować podstawowych zależności"
    
    log "Instalacja dodatkowych pakietów..."
    sudo pacman -S --needed --noconfirm git neovim vim nsxiv fish fastfetch kitty stow starship trash-cli sxhkd nitrogen picom dunst polkit-gnome numlockx network-manager-applet parcellite feh
    check_success "Nie udało się zainstalować dodatkowych pakietów"
elif [ "$DISTRO" = "ubuntu" ]; then
    log "Instalacja zależności DWM dla Ubuntu..."
    sudo apt update
    check_success "Nie udało się zaktualizować listy pakietów"
    
    sudo apt install -y build-essential libx11-dev libxinerama-dev libxft-dev libxcb1-dev libxcb-keysyms1-dev libxcb-icccm4-dev libx11-xcb-dev libxcb-util0-dev libxcb-randr0-dev suckless-tools libfreetype6-dev
    check_success "Nie udało się zainstalować podstawowych zależności"
    
    log "Instalacja dodatkowych pakietów..."
    sudo apt install -y git neovim vim fish fastfetch kitty nsxiv stow starship trash-cli sxhkd nitrogen picom dunst policykit-1-gnome numlockx network-manager-gnome parcellite feh neofetch
    check_success "Nie udało się zainstalować dodatkowych pakietów"
fi

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

git clone https://github.com/trebuhw/.dotfiles ~/.dotfiles
check_success "Nie udało się sklonować repozytorium"

# Tworzenie kopii zapasowych
log "Tworzenie kopii zapasowych plików konfiguracyjnych..."
[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
[ -f ~/.bash_logout ] && mv ~/.bash_logout ~/.bash_logout.bak
[ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.bash_profile.bak

# Stow
log "Tworzenie symlinków za pomocą stow..."
cd ~/.dotfiles || { error "Nie można przejść do katalogu ~/.dotfiles"; exit 1; }
stow bash/ fastfetch/ nsxiv/ suckless/ dunst/ fish/ kitty/ fish/ starship/ themes/ icons/ background/
check_success "Błąd podczas wykonywania stow"

# Kompilacja i instalacja DWM
log "Kompilacja i instalacja DWM..."
cd ~/.config/suckless/dwm || { error "Nie można przejść do katalogu DWM"; exit 1; }
[ -f config.h ] && rm config.h
sudo make && sudo make clean install
check_success "Błąd podczas kompilacji DWM"

# Kompilacja i instalacja slstatus
log "Kompilacja i instalacja slstatus..."
cd ~/.config/suckless/slstatus || { error "Nie można przejść do katalogu slstatus"; exit 1; }
[ -f config.h ] && rm config.h
sudo make && sudo make clean install
check_success "Błąd podczas kompilacji slstatus"

# Kompilacja i instalacja st
log "Kompilacja i instalacja st (terminal)..."
cd ~/.config/suckless/st || { error "Nie można przejść do katalogu st"; exit 1; }
sudo make && sudo make clean install
check_success "Błąd podczas kompilacji st"

# Instalacja pliku .desktop
log "Kopiowanie pliku .desktop..."
sudo cp ~/.config/suckless/usr/share/xsessions/dwm.desktop /usr/share/xsessions/
check_success "Nie udało się skopiować pliku .desktop"

log "Instalacja zakończona pomyślnie!"
log "Aby uruchomić DWM, wyloguj się i wybierz sesję DWM z menedżera logowania."

source ~/.bashrc
tofish

# Pytanie o reboot
read -p "Czy chcesz teraz zrestartować system? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "Restartuję system..."
    sudo systemctl reboot
fi

exit 0
